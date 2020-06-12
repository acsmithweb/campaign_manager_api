Rails.application.routes.draw do
  resources :stat_blocks
  delete 'stat_blocks_destroy', to: 'stat_blocks#bulk_destroy'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
