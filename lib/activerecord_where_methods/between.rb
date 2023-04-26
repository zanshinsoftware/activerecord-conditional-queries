require "active_record"

module ActiverecordWhereMethods
  module Between

    def between opts, *rest
      opts.each do |column, opt|
        @scope.where_clause += build_left_where_clause(column, opt[:from], opt[:kind]) if opt[:from].present?
        @scope.where_clause += build_right_where_clause(column, opt[:to], opt[:kind]) if opt[:to].present?
      end

      @scope
    end

    private
      def build_left_where_clause column, value, kind = nil
        build_where_clause column, ajust_value_by_kind(value, kind, false)..
      end

      def build_right_where_clause column, value, kind = nil
        build_where_clause column, ..ajust_value_by_kind(value, kind, true)
      end

      def build_where_clause column, value
        @scope.send :build_where_clause, column => value
      end

      def ajust_value_by_kind value, kind, right = true
        case kind
        when :datetime then ajust_datetime(value, right)
        else
          value
        end
      end

      def ajust_datetime value, right
        if right
          value.end_of_day
        else
          value.beginning_of_day
        end
      end
  end
end

ActiveSupport.on_load :active_record do
  ActiveRecord.eager_load!

  ActiveRecord::QueryMethods::WhereChain.send :include, ActiverecordWhereMethods::Between
end
