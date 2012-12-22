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
        parser.parse(query).tap do |result|
          raise Error, parser.failure_reason unless result
        end.to_criteria
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
      def to_criteria(tags = nil)
        {}.tap do |criteria|
          (tags.presence || elements).each do |tag|
            (criteria[tag.operator.selector] ||= []) << tag.to_criteria if tag.is_a? Tag
            
            criteria.merge!(to_criteria(tag.elements)) { |key, first, second| first + second } if tag.elements.present?
          end
        end
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
