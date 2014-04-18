require 'active_support'
require 'mongoid'
require 'treetop'

module Mongoid
  module Tags
    extend ActiveSupport::Concern

    included do |base|
      field :tags, type: Array, default: []
      index tags: 1
    end

    module ClassMethods
      def selector(query)
        parsed_query = parser.parse(query)
        raise Mongoid::Tags::Error, parser.failure_reason unless parsed_query

        parsed_query.to_criteria
      end

      def tagged(query)
        where(tags: selector(query))
      end

    private
      def parser
        @parser ||= Treetop.load(File.expand_path('../tags.tt', __FILE__)).new
      end
    end

    class Query < Treetop::Runtime::SyntaxNode
      def to_criteria(elements = nil)
        elements ||= self.elements

        criteria = Hash.new { |h, k| h[k] = [] }

        elements.each do |element|
          criteria[element.operator.selector] << element.to_criteria if element.is_a?(Tag)

          criteria.merge! to_criteria(Array(element.elements)) do |_, first, second|
            first + second
          end
        end

        criteria
      end
    end

    class Tag < Treetop::Runtime::SyntaxNode
      def to_criteria
        tag.text_value
      end
    end

    class OrOperator < Treetop::Runtime::SyntaxNode
      def selector
        '$in'
      end
    end

    class AndOperator < Treetop::Runtime::SyntaxNode
      def selector
        '$all'
      end
    end

    class NotOperator < Treetop::Runtime::SyntaxNode
      def selector
        '$nin'
      end
    end

    class Error < StandardError; end
  end
end
