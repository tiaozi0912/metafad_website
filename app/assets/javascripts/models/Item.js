window.Item = Backbone.Model.extend() //attr: brand,tags,price,poll_id,id
window.ItemCollection = Backbone.Collection.extend({
	model:Item
})