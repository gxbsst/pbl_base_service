class Region < PgConnection
  acts_as_tree
end

class Country < Region;end
class Province < Country;end
class City < Province;end
class District < City;end


