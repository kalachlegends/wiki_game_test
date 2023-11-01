defmodule WikiGameTest.Use.RepoBase do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @moduledoc """


      # Базовые функции для модели `#{__MODULE__}`

          ## Example
          ```
          iex>  #{__MODULE__}.get_all(
            type_private: :public, # все поля которые не в use_query попадают в where
            use_query: %{
              order_by: [asc: :inserted_at]
              preload: [:user, :tree],
             search: %{
              key: name,
              value: "value"
              },
             pagination: %{
              page: page,
              limit: limit
              }
            }
          )
          # Если есть пагинация вернет мапу с количеством
          {:ok, %{count: 2, item: []}}

          # в use_query можно использовать select:
          # Если его не будет вернет все поля данной схемы
          # Example:
          #{__MODULE__}.get_all(
              use_query: %{
                preload: [:user]
                select: [user: :login, :id] +   #{__MODULE__}.fields()
              }
            }
          )

          # Чтобы не перечислять все поля можно использовать

          #{__MODULE__}.fields()

          # если надо использовать дополнительные функции то можно испольльзовать ключ query_function
          # Он принимает в себя функцию которая принимает запрос Ecto.Query
          #{__MODULE__}.get_all(
              use_query: %{
                preload: [:user]
                query_function: fn query ->
                  query
                  |> where([w], w.id == 1)
                end
              }
            }
          )

          ```

          ## В Этом модуле так же есть

          ```
          #{__MODULE__}.update_by_id(id, map)
          {:ok, item} ||   {:error, reason}
          ```
          ## В use_query можно использовать для подсчета выдаст количество элементов по значению
          ```

              aggregate_attrs: %{
                aggregate: :count,
                attrs: :id
              },
          ```
      """
      import Ecto.Query, only: [from: 2, where: 2, where: 3, offset: 2, limit: 2]

      @repo opts[:repo]
      @on_created opts[:on_created] || nil
      @ignore_fields opts[:ignore_fields] || []
      @not_fount_message opts[:error_message] || :not_found

      @doc """
      # Создает структуру

      Возвращает `{:ok, item}` или `{:error, error_changeset}`
      ## Example
      ```
      #{__MODULE__}.create(%{name: "artem"})
      ```
      """
      def create(map) do
        __MODULE__.changeset(%__MODULE__{}, map)
        |> @repo.insert()
      end

      @doc """
      # Возвращает все поля в scheme


      ## Example
      ```
      iex> #{__MODULE__}.fields()
      [:id, :name]

      ```

      ## Можно фильтровать значения которые не нужны
      ```
      iex> #{__MODULE__}.fields([:id])
      [:name]
      ```

      """
      def fields(filtered \\ []) when is_list(filtered) do
        schema = __MODULE__.__schema__(:fields)

        if filtered != [] do
          schema
          |> Enum.filter(fn x ->
            !(x in filtered)
          end)
        else
          schema
        end
      end

      @doc """
      Возвращает структуру по ее id или по соответствию значения полей структуры
      """
      def get!(opts) when is_list(opts) or is_map(opts) do
        try do
          query_bindings(opts)
        rescue
          Ecto.Query.CastError -> nil
        end
      end

      def get!(item_id) do
        try do
          @repo.get(__MODULE__, item_id)
        rescue
          Ecto.Query.CastError -> nil
        end
      end

      @doc """
      ## Возвращает структуру по ее id или по соответствию значения полей структуры

      ## Example
      ```
      #{__MODULE__}.get(
        type_private: :public,
        use_query: %{
          order_by: [asc: :inserted_at]
          preload: [:user, :tree]data
        }
      )
      ```
      """
      def get(item_id_or_opts) do
        case get!(item_id_or_opts) do
          %__MODULE__{} = item -> {:ok, item}
          nil -> {:error, @not_fount_message}
        end
      end

      def exists?(opts) when is_list(opts) or is_map(opts) do
        from(i in __MODULE__, select: i)
        |> filter(opts)
        |> @repo.exists?()
      end

      @doc """
      ## Возвращает список всех имеющихся структур или по соответствию значения полей структуры

      ## Example
      ```

      #{__MODULE__}.get_all(
        type_private: :public,
        use_query: %{data
          aggregate_attrs: %{
            aggregate: :id,

          }
         search: %{
          key: name,
          value: "value"
          },
         pagination: %{
          page: page,
          limit: limit
          }
        }
      )

      ```

        ## В use_query можно использовать для подсчета выдаст количество элементов по значению
          ```
            aggregate_attrs: %{
              aggregate: :count,
               attrs: :id
            },
          ```
      """
      def get_all!(opts \\ nil) do
        try do
          query_bindings(opts, :all)
        rescue
          Ecto.Query.CastError -> []
        end
      end

      @doc """
      # Возвращает список всех имеющихся структур или по соответствию значения полей структуры

      ## Example
      ```
      iex> #{__MODULE__}.get_all(
        type_private: :public, # все поля которые не в use_query попадают в where
        use_query: %{
          order_by: [asc: :insertdataed_at]
          preload: [:user, :tree],
         search: %{
          key: name,
          value: "value"
          },
         pagination: %{
          page: page,
          limit: limit
          }
        }
      )
      # Если есть пагинация вернет мапу с количеством
      {:ok, %{count: 2, item: []}}

      # в use_query можно использовать select:
      # Если его не будет вернет все поля данной схемы
      # Example:
      #{__MODULE__}.get_all(
          use_query: %{
            preload: [:user]
            select: [user: :login, :id] +  __MODULE__.fields()
          }
        }
      )

      # Чтобы не перечислять все поля можно использовать

      #{__MODULE__}.fields()

      # если надо использовать дополнительные функции то можно испольльзовать ключ query_function
      # Он принимает в себя функцию которая принимает запрос Ecto.Query
      #{__MODULE__}.get_all(
          use_query: %{
            preload: [:user]
            query_function: fn query ->
              query
              |> where([w], w.id == 1)
            end
          }
        }
      )


      ```
      """
      def get_all(opts \\ nil) do
        case get_all!(opts) do
          [] -> {:error, @not_fount_message}
          items -> {:ok, items}
        end
      end

      @doc """
      Создает структуру
      """
      def add(opts) do
        %__MODULE__{}
        |> __MODULE__.changeset(opts_to_map(opts))
        |> @repo.insert()
      end

      def update(%__MODULE__{} = item, opts, attrs \\ []) do
        item
        |> __MODULE__.changeset(opts_to_map(opts))
        |> @repo.update(attrs)
      end

      def update_or_create(nil, params_update_or_create) do
        add(params_update_or_create)
      end

      def update_or_create(params_to_get, params_update_or_create) do
        case get(params_to_get) do
          {:ok, item} ->
            update(item, params_update_or_create)

          {:error, item} ->
            add(params_update_or_create)
        end
      end

      def update_by_id(id, opts) do
        with {:ok, item} <- get(id: id),
             {:ok, item} <- update(item, opts) do
          {:ok, item}
        end
      end

      def update_by_opts(opts_update, opts, attrs \\ []) do
        with {:ok, item} <- get(opts_update),
             {:ok, item} <- update(item, opts, attrs) do
          {:ok, item}
        end
      end

      @doc """
      # You must have items with id
      """
      def update_all_by_items_multi(list_updates_items) do
        if !is_nil(list_updates_items) do
          Enum.reduce(list_updates_items, Ecto.Multi.new(), fn x, acc ->
            x =
              convert_keys(x)
              |> Map.delete(:inserted_at)
              |> Map.delete(:updated_at)

            changest =
              get!(x[:id])
              |> Ecto.Changeset.change(x)

            acc
            |> Ecto.Multi.update(x[:id] |> String.to_atom(), changest)
          end)
          |> @repo.transaction()
        else
          {:ok, []}
        end
      end

      @doc """
      # You must have items with id
      """
      def update_all_by_items(list_updates_items) do
        Enum.map(list_updates_items, fn x ->
          x = x |> convert_keys()

          update_by_id(x[:id], x)
        end)
      end

      @doc """
      # Удаляет запись по id, item или map
      """
      def delete(%__MODULE__{} = item) do
        try do
          @repo.delete(item)
        rescue
          _ -> {:error, @not_fount_message}
        end
      end

      @doc """
      # Remove by id
      """
      def delete(id) when is_bitstring(id) or is_integer(id) do
        with {:ok, item} <- get(id),
             {:ok, item} <- delete(item) do
          {:ok, item}
        end
      end

      @doc """
      # Remove by item_id_or_opts
      """
      def delete(item_id_or_opts) when is_map(item_id_or_opts) do
        with {:ok, item} <- get(item_id_or_opts),
             {:ok, item} <- delete(item) do
          {:ok, item}
        end
      end

      defp filter(query, []), do: query
      defp filter(query, %{}), do: query
      defp filter(query, opts), do: filter(query, opts, Enum.count(opts), 0)

      defp filter(query, opts, count, acc) do
        fields = Map.new([Enum.at(opts, acc)]) |> Map.to_list()
        result = query |> where(^fields)

        if acc < count - 1, do: filter(result, opts, count, acc + 1), else: result
      end

      defp select(query, opts \\ %{}) do
        select_opts = opts[:select]

        cond do
          select_opts == false -> query
          !is_list(select_opts) -> Ecto.Query.select(query, [w], w)
          true -> Ecto.Query.select(query, [w], struct(w, ^select_opts))
        end
      end

      def query_bindings(opts \\ %{}, mode \\ :one, query_other \\ false) do
        query = from(i in __MODULE__, [])
        use_query = opts[:use_query] || %{}
        only_query = use_query[:only_query] || false
        aggregate_attrs = use_query[:aggregate_attrs]
        use_query_name = use_query[:name] || __MODULE__.__schema__(:source)
        pagination_valid = use_query[:pagination_valid]

        query =
          if !query_other do
            as_var = __MODULE__.__schema__(:source) |> normalize_atom
            from(i in __MODULE__, as: ^as_var)
          else
            query_other
          end

        {query, count} =
          if is_nil(opts) do
            {query, nil}
          else
            query
            |> filter(ignore_fields(opts))
            |> order_by(use_query)
            |> search(use_query)
            |> preload(use_query)
            |> query_function(use_query)
            |> select(use_query)
            |> pagination(use_query, mode)
          end

        cond do
          !is_nil(aggregate_attrs) ->
            count = @repo.aggregate(query, aggregate_attrs[:aggregate], aggregate_attrs[:opts])
            if is_nil(count), do: 0, else: count

          mode == :one and !only_query ->
            @repo.one(query)

          is_nil(count) and mode == :all and !only_query ->
            @repo.all(query)

          !is_nil(count) and mode == :all and !only_query ->
            repo_all = @repo.all(query)

            cond do
              repo_all != [] ->
                %{use_query_name => repo_all, "count" => count}

              repo_all == [] && pagination_valid ->
                %{use_query_name => repo_all, "count" => count}

              true ->
                []
            end

          true ->
            query
        end
      end

      defp query_function(query, opts \\ %{}) do
        query_function = opts[:query_function]

        if is_function(query_function) do
          query_function.(query)
        else
          query
        end
      end

      defp order_by(query, opts \\ %{}) do
        order_map = opts[:order_by]

        if is_list(order_map) do
          Ecto.Query.order_by(query, ^order_map)
        else
          query
        end
      end

      defp search(query, opts \\ %{}) do
        search = opts[:search]
        key = search[:key]
        value = search[:value]
        type = search[:type] || :ilike

        cond do
          is_map(search) and type == :like and key == :name ->
            Ecto.Query.where(query, [c], ilike(c.name, ^value))

          is_map(search) and type == :ilike and key == :name ->
            Ecto.Query.where(query, [c], ilike(c.name, ^value))

          is_map(search) and type == :like and key == :description ->
            Ecto.Query.where(query, [c], like(c.description, ^value))

          is_map(search) and type == :ilike and key == :description ->
            Ecto.Query.where(query, [c], ilike(c.description, ^value))

          true ->
            query
        end
      end

      defp pagination(query, opts \\ %{}, mode) do
        pagination_map = opts[:pagination]

        if mode != :one and is_map(pagination_map) do
          limit = limit_pagination(pagination_map[:limit])
          page = pagination_map[:page]

          if is_nil(page) do
            {query, 0}
          else
            page = check_bitstring_and_convert_int(page) - 1
            offset = page * limit
            count = @repo.aggregate(query, :count, :id)

            item = query |> limit(^limit) |> offset(^offset)
            {item, count}
          end
        else
          {query, nil}
        end
      end

      defp limit_pagination(limit) do
        if is_nil(limit) do
          10
        else
          check_bitstring_and_convert_int(limit)
        end
      end

      defp check_bitstring_and_convert_int(type) do
        cond do
          is_bitstring(type) -> String.to_integer(type)
          is_integer(type) -> type
          true -> throw("Unkown_type_for_pagination")
        end
      end

      defp preload(query, opts \\ %{}) do
        order_map = opts[:preload]

        if is_list(order_map) do
          Ecto.Query.preload(query, ^order_map)
        else
          query
        end
      end

      defp ignore_fields(opts) do
        Enum.map(opts, fn {key, value} ->
          key = normalize_atom(key)
          list = [:use_query, :version] ++ @ignore_fields

          if key in list do
            nil
          else
            {key, value}
          end
        end)
        |> Enum.filter(fn x -> !is_nil(x) end)
      end

      defp normalize_atom(atom) when is_atom(atom), do: atom
      defp normalize_atom(atom) when is_binary(atom), do: atom |> String.to_atom()

      defp opts_to_map(opts) when is_map(opts),
        do:
          opts
          |> Map.new(fn {k, v} ->
            if is_binary(k) do
              {String.to_atom(k), v}
            else
              {k, v}
            end
          end)

      defp opts_to_map(opts) when is_list(opts) do
        Enum.reduce(opts, %{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
      end

      def get_case(item) do
        case item do
          {:ok, item} -> item
          {:error, _item} -> nil
        end
      end

      defp convert_keys(map) when is_map(map) do
        Enum.reduce(map, %{}, fn {key, value}, acc ->
          converted_key = String.to_existing_atom(key)
          new_value = convert_value(value)
          Map.put(acc, converted_key, new_value)
        end)
      end

      defp convert_value(value) do
        if is_map(value) do
          convert_keys(value)
        else
          value
        end
      end
    end
  end

  defp normalize_atom(string) when is_bitstring(string) do
    string |> String.to_atom()
  end

  defp normalize_atom(string) when is_atom(string) do
    string
  end
end
