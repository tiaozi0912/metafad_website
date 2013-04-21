window.User = Backbone.Model.extend({
	urlRoot: '/web/users',
	initialize: function(){
		if (this.get('tab') == 'stores') this.urlRoot = '/web/stores/users';
	}
}); 