window.Gallery = Backbone.Model.extend({ //attributes: currTag,category[colors,brands]
  defaults: {
    settings: {
      colors: {'dusk_blue':'rgb(91,145,181)',
               'linen':'rgb(241,208,181)',
               'poppy_red':'rgb(200,20,20)',
               'emerald':'rgb(0,150,127)',
               'grayed_jade':'rgb(141,171,163)',
               'lemon_zest':'rgb(254,219,63)',
               'monaco_blue':'rgb(24,43,83)',
               'nectarine':'rgb(243,113,51)',
               'rose_smoke':'rgb(223,193,185)',
               'tender_shoots':'rgb(163,190,57)',
               'violet':'rgb(153,108,175)'
              },
      brands: ['burberry','celine','chanel','chloe','christian_dior','dolce_&_gabbana','donnakaran','elie_saab','fendi','valentino'],
      rows:3
    },
  },
  initialize: function(){
    this.initializeCollection();
    this.bind('change:currTag category',this.initializeCollection);
  },
  initializeCollection: function(){
    var model = this;
    var currTag = model.get('currTag');
    var category = model.get('category');
    var settings = model.get('settings');
    //console.log('category is:'+category);
    //console.log('current tag is:'+currTag);
    var tags = settings[category]; 
    var collection = new TagCollection();
    if(category == 'colors'){
      for(var colorName in settings.colors){
        var isSelected = (colorName == currTag);
        collection.add(new Tag({name:colorName,category:category,isSelected:isSelected,rgb:settings.colors[colorName]}));
      }
    }else if(category == 'brands'){
      _.each(settings.brands,function(el){
        var isSelected = (el == currTag);
        collection.add(new Tag({name:el,category:category,isSelected:isSelected}));
      });
    }
    this.set({collection:collection});
  }
});

window.Tag = Backbone.Model.extend({ //attributes:name,category，isSelected
  defaults: {
    settings:{
      photosNum:9,
      extension:"jpg",
      baseURL: "/images/gallery/",
    },
    name:"",
    category:""
  },
  initialize:function(){
    var collection = new PhotoCollection();
    var settings = this.get('settings');
    for(var i=0;i<settings.photosNum;i++){
      var photo = new Photo({
        category:this.get('category'),
        tag:this.get('name'),
        src:this.src(i),
        name:(i+1).toString()}
      );
      collection.add(photo);
    }
    this.set({collection:collection});
    this.setURL();
  },
  src: function(i){
    var settings = this.get('settings');
    var photoName = (i+1).toString();
    return settings.baseURL + this.get('category') + "/" + this.get('name') + "/" + photoName + "." + settings.extension;
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
