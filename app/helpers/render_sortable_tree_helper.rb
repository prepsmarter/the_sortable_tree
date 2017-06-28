# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        "
          <li data-node-id='#{ node.id }'>
            <div class='item'>
              <i class='handle'></i>
              #{'<b class="expand minus">-</b>' unless children.blank?}
              #{ show_link }
              #{ controls }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        url = h.url_for(:controller => 'admin/' + options[:klass].pluralize, :action => :show, :id => node)
        title_field = options[:title]

        "<h4>#{ h.link_to node.send(title_field), url,  target: '_edit_topic' }</h4>"
      end
      def controls
        node = options[:node]
        edit_path = h.url_for(controller: 'admin/' + options[:klass].pluralize, action: :edit, id: node)
        destroy_path = h.url_for(controller: options[:klass].pluralize, action: :destroy, id: node)
        new_path = h.url_for(controller: options[:klass].pluralize, action: :new, topic: { parent_id: node })
        new_evoke_path = h.url_for("/admin/topics/#{node.id}/evokes")
        topic_references_path = h.url_for("/topics/#{node[:topic_id]}/references")

        "
          <div class='controls'>
            #{h.link_to '', '#', class: :new, data: { 'reveal-id': 'newTopic', parent_id: node[:topic_id] }}
            #{h.link_to '', edit_path, class: :edit, target: '_edit_topic'}
            #{h.link_to '', destroy_path, class: :delete, method: :delete, data: { confirm: 'Are you sure?' }}
            #{h.link_to '', new_evoke_path, class: :evokes, target: '_evokes'}
            #{h.link_to '', topic_references_path, class: :references, target: '_references'}
          </div>
        "
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
