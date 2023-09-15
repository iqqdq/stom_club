// ignore_for_file: non_constant_identifier_names

abstract class URLs {
  static var base_url = 'https://odont.club/api/';
  static var media_url = 'https://odont.club';

  static var users_url = base_url + 'users/';
  static var refresh_url = base_url + 'users/token/refresh/';
  static var auth_url = users_url + 'make_call/';

  static var companies_url = base_url + 'companies/';
  static var professions_url = base_url + 'professions/';
  static var banners_url = base_url + 'banners/';
  static var categories_url = base_url + 'categories/';
  static var manufacturers_url = base_url + 'manufacturers/';
  static var products_url = base_url + 'products/';
  static var articles_url = base_url + 'articles/';
}
