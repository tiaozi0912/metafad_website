window.Gallery = Backbone.Model.extend({ //attributes: currTag,category[colors,brands],polls(array of json object)
  defaults: {
    settings: {
      palette: {'dusk blue':'rgb(91,145,181)',
               'linen':'rgb(241,208,181)',
               'poppy red':'rgb(200,20,20)',
               'emerald':'rgb(0,150,127)',
               'grayed jade':'rgb(141,171,163)',
               'lemon zest':'rgb(254,219,63)',
               'monaco blue':'rgb(24,43,83)',
               'nectarine':'rgb(243,113,51)',
               'rose smoke':'rgb(223,193,185)',
               'tender shoots':'rgb(163,190,57)',
               'violet':'rgb(153,108,175)'
              },
      rows:3
    },
  },
  initialize: function(){
    this.initializeCollection();
    this.bind('change:currTag category polls',this.initializeCollection,this);
  },
  initializeCollection: function(){
    var model = this;
    var polls = model.get('polls');
    var currTag = model.get('currTag');
    var category = model.get('category');
    var settings = model.get('settings');
    var collection = new TagCollection();
    _.each(polls,function(p){
      var isSelected = (p.title == currTag);
      var tagProperties = {name:p.title,category:category,isSelected:isSelected,photos:p.items};
      if(category == 'colors'){
        tagProperties.rgb = settings.palette[p.title];
      }
      collection.add(new Tag(tagProperties));
    });
    this.set({collection:collection}); //collection reset
  }
});

window.Tag = Backbone.Model.extend({ //attributes:name,category，isSelected, photos(array of objects)
  defaults: {
    settings:{
      photosNum:9
    }
  },
  initialize:function(){
    var collection = new PhotoCollection();
    var settings = this.get('settings');
    for(var i=0;i<settings.photosNum;i++){
      var property = this.get('photos')[i];
      property.category = this.get('category');
      property.tag = this.get('name');
      property.id = 'gallery-item-' + property.id.toString();
      var photo = new Photo(property);
      collection.add(photo);
    }
    this.set({collection:collection});
    this.setURL();
  },
  src: function(i){
    var photo = this.get('photos')[i];
    return photo.photo_url
  },
  setURL: function(){
    var url = '#gallery/' + this.get('category') + '/' + this.get('name');
    this.set({url:url});
  }
});

window.Photo = Backbone.Model.extend(); //attributs: tag,category,src,name


//Collections
window.PhotoCollection = Backbone.Collection.extend({
	model: Photo
});
window.TagCollection = Backbone.Collection.extend({
	model: Tag
});
