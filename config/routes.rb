Rails.application.routes.draw do
  post '/chat', action: :chat, controller: 'chat_client'
  resources :workbooks
  delete 'workbooks_destroy', to: 'workbooks#bulk_destroy'
  resources :spells
  delete 'spells_destroy', to: 'spells#bulk_destroy'
  resources :stat_blocks
  delete 'stat_blocks_destroy', to: 'stat_blocks#bulk_destroy'
  resources :items
  delete 'items_destroy', to: 'items#bulk_destroy'
  resources :workbooks
  delete 'workbooks_destroy', to: 'workbooks#bulk_destroy'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
