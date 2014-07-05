module Hub
  class Product
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic
    include Mongoid::Timestamps
    include Hub::AfterSave

    belongs_to :connection, class_name: 'Setup::Connection'

    embeds_many :variants, class_name: 'Hub::Variant'
    embeds_many :images, class_name: 'Hub::Image'

    embeds_many :taxons, class_name: 'Hub::Taxon'
    embeds_many :properties, class_name: 'Hub::Property'

    accepts_nested_attributes_for :variants
    accepts_nested_attributes_for :images
    accepts_nested_attributes_for :properties
    accepts_nested_attributes_for :taxons

    field :id, type: String
    field :name, type: String
    field :sku, type: String
    field :description, type: String
    field :price, type: Float
    field :cost_price, type: Float
    field :available_on, type: Date
    field :permalink, type: String
    field :meta_description, type: String
    field :meta_keywords, type: String
    field :shipping_category, type: String
    field :options, type: Array

    validates_presence_of :id, :name, :price, :available_on, :shipping_category

    validates_numericality_of :price, { greater_than: 0 }

  end
end
