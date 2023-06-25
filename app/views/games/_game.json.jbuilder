json.extract! game, :id, :name, :desc, :members, :created_at, :updated_at
json.url game_url(game, format: :json)
