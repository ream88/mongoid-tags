require 'active_support'
require 'mongoid'
require 'treetop'

module Mongoid
  module Tags
    extend ActiveSupport::Concern

    # @!attribute tags
    #   @return [Array] all tags of the current document
    included do |base|
      field :tags, type: Array, default: []
      index tags: 1
    end

    module ClassMethods
      ##
      # Returns a hash representing a Mongoid criteria
      # for the given tag query.
      #
      # @example
      #   hash = Document.selector('foo bar')
      #   hash # => {"tags"=>{"$in"=>["foo", "bar"]}}
      #
      # @param [String] query The query you're searching for
      #
      # @return [Hash] Hash which can be used as a Mongoid criteria
      def selector(query)
        parsed_query = parser.parse(query)
        raise Mongoid::Tags::Error, parser.failure_reason unless parsed_query

        parsed_query.to_criteria
      end

      ##
      # Returns a chainable criteria for all documents
      # found by the given tag query.
      #
      # @example
      #   documents = Document.tagged('foo bar')
      #   documents # all documents tagged foo OR bar
      #
      # @param [String] query The query you're searching for
      #
      # @return [Mongoid::Criteria] Mongoid criteria to retrieve all matching documents
      def tagged(query)
        where(selector(query))
      end

    private
      def parser
        @parser ||= Treetop.load(File.expand_path('../tags.tt', __FILE__)).new
      end
    end

    ##
    # Representation class for a tag query, e.g. `foo bar`.
    #
    # @api private
    class Query < Treetop::Runtime::SyntaxNode
      ##
      # Returns a hash representing a Mongoid criteria
      # for the current query.
      #
      # @api private
      #
      # @param elements
      #
      # @return [Hash] Hash which can be used as a Mongoid criteria
      def to_criteria(elements = nil)
        elements ||= self.elements

        criteria = { 'tags' => Hash.new { |h, k| h[k] = [] } }

        elements.each do |element|
          criteria['tags'][element.operator.selector] << element.to_criteria if element.is_a?(Tag)

          criteria['tags'].merge! to_criteria(Array(element.elements))['tags'] do |_, first, second|
            first + second
          end
        end

        criteria
      end
    end

    ##
    # Representation class for a subquery, e.g. `(foo bar)`.
    #
    # @api private
    class SubQuery < Treetop::Runtime::SyntaxNode
      ##
      # Returns a hash representing a Mongoid criteria
      # for the current query.
      #
      # @api private
      #
      # @param elements
      #
      # @return [Hash] Hash which can be used as a Mongoid criteria
      def to_criteria(elements = nil)
        elements ||= self.elements

        criteria = []
        subcriteria = { '$or' => [] }

        elements.each do |element|
          case element
          when Query
            criteria << element.to_criteria
          when SubQuery
            element.to_criteria['$or'].each do |criterion|
              criteria << criterion
            end
          end
        end

        criteria.each do |criterion|
          subcriteria['$or'] << criterion
        end

        subcriteria
      end
    end

    ##
    # Representation class for a tag, e.g. `foo`.
    #
    # @api private
    class Tag < Treetop::Runtime::SyntaxNode
      ##
      # Returns a string for using this tag in a Mongoid criteria.
      #
      # @api private
      #
      # @return [String] String representing this tag for a Mongoid criteria
      def to_criteria
        tag.text_value
      end
    end

    ##
    # Representation class for "or" operator, e.g. ` `.
    #
    # @api private
    class OrOperator < Treetop::Runtime::SyntaxNode
      ##
      # Returns a string for using this operator in a Mongoid criteria.
      #
      # @api private
      #
      # @return [String] String representing this operator for a Mongoid criteria
      def selector
        '$in'
      end
    end

    ##
    # Representation class for "and" operator, e.g. `+`.
    #
    # @api private
    class AndOperator < Treetop::Runtime::SyntaxNode
      ##
      # Returns a string for using this operator in a Mongoid criteria.
      #
      # @api private
      #
      # @return [String] String representing this operator for a Mongoid criteria
      def selector
        '$all'
      end
    end

    ##
    # Representation class for "not" operator, e.g. `-`.
    #
    # @api private
    class NotOperator < Treetop::Runtime::SyntaxNode
      ##
      # Returns a string for using this operator in a Mongoid criteria.
      #
      # @api private
      #
      # @return [String] String representing this operator for a Mongoid criteria
      def selector
        '$nin'
      end
    end

    class Error < StandardError; end
  end
end
