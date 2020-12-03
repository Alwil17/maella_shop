class SliderModel{
  String title;
  String desc;
  String imageAssetPath;

  SliderModel({this.title, this.desc});

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }
}

List<SliderModel> getSlides(){
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  sliderModel.setTitle('Maella Shop');
  sliderModel.setDesc('Bienvenue sur Maella Shop! Achetez nos produits en toute facilite et faites-vous livrer.');
  sliderModel.setImageAssetPath('assets/sIcon.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Search');
  sliderModel.setDesc('Search among 1 million products. The choice is yours.');
  sliderModel.setImageAssetPath('assets/onBoarding/search.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Delivery');
  sliderModel.setDesc('Super fast delivery. Right at your doorstep');
  sliderModel.setImageAssetPath('assets/onBoarding/products-delivery.png');
  slides.add(sliderModel);

  return slides;
}