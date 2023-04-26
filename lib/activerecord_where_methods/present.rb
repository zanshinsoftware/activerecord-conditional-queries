require "active_record"

module ActiverecordWhereMethods
  module Present

    def present opts, *rest
      opts.select! { |k, v| v.present? }

      if opts.any?
        @scope.where_clause += @scope.send :build_where_clause, opts, rest
      end

      @scope
    end

  end
end

ActiveSupport.on_load :active_record do
  ActiveRecord.eager_load!

  ActiveRecord::QueryMethods::WhereChain.send :include, ActiverecordWhereMethods::Present
end
