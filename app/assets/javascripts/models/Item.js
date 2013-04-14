window.Item = Backbone.Model.extend() //attr: brand,tags,price,poll_id,id,number_of_votes
window.ItemCollection = Backbone.Collection.extend({
	model:Item
})