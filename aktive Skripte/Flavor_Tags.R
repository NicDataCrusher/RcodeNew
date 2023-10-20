#### creating Tags ####

hop_tags <- c("citrus", "floral", "pine",  "herbal", "spice", "tropical", "resin", "grapefruit", "lemon", "orange", "mango", "passionfruit", "melon", "grass", "dank", "elderflower", "elderberry", "pepper", "gooseberry", "mint", "lilac", "geranium", "violets", "black currant", "cassis")
malt_tags <- c("nut", "vanilla", "honey", "smoke", "smoky", "toast", "caramel", "licorice", "cocoa", "chocolate", "raisins", "brown bread", "white bread", "coffee", "cinnamon", "earthy", "hazelnut", "peat")
yeast_tags <- c("passionfruit", "garlic", "banana", "peach", "apricot", "apple", "green", "pear", "glue", "sulfur", "rose", "onion", "butter", "cabbage", "dryed fruits", "funky", "horse", "wild")
offFlavor_tags <- c("green apple", "pharmacy", "corn", "boiled vegetables", "hemp", "skunk", "iron", "rancid", "sour", "vinegar", "cheese", "rotten eggs", "lactic", "medicinal", "chlorin", "tabakko", "cat", "light", "caramel", "cartonage")
taste_tags <- c("sweet", "sour", "bitter", "umami", "salty")
foam_tags <- c("creamy", "dense", "frothy", "puffy", "rich", "thin", "velvety", "voluminous", "bubbly")
clarity_tags <- c("clear", "cloudy", "chrystalline", "hazy", "murky", "opaque", "opal", "translucent")
color_tags <- c("yellow", "orange", "amber", "foam", "white", "egg", "shell", "blonde", "brown", "copper", "dark", "golden", "mahagony", "pale", "reddish", "ruby", "straw", "tan")
haptic_tags <- c("bubbly", "carbonated", "fizzy", "flat", "sparkling")
categorial_tags <- c("easy", "aged", "unpleasant", "balanced", "light", "strong", "smooth", "fruity", "tropical", "classic", "hazy", "complex","smooth", "funky", "dark", "session", "enjoyable")
local_tags <- c("german","american", "belgium", "australian", "african", "neighborhood", "community", "district", "region", "area", "zone", "territory", "province", "municipality", "city", "town", "village", "suburb", "county", "state", "country", "locale", "vicinity", "surroundings", "environment", "valley")
adjuncs_tags <- c("coriander", "blueberry", "cherry", "infused", "grape", "rice", "rhye", "pumpkin")

default_stopwords <- stopwords("en")
words_to_remove <- c("don't", "not", "can't", "cannot") # I was interested in the rank for these words, connotated with the word "recommmend" thats why i kept them
container_stopwords <- c( "case",  "mi", "bottle", "barell", "can", 
                      "cork", "glass", "drink", "teku", "just", "snifter", "bomber", "boot", "chalice", "flute", "goblet", "glass", "mass", "mug", "pint", "pokal", "stein", "tankard", "teku", "thistle", "tumbler", "willi", "becher", "wine", "yard",
                      "tulip", "oz", "0%", "liter", "drink", "drank", "ml", 
                      "milliliter", "mils", "ounces", 
                       "growler",
                      "\u0085\u0085\u0085\u0085\u0085",
                      "\u0085\u0085\u0085\u0085slow","\u0085\u0085ha",                        
                      "\u0085\u0085i","\u0085\u0085now",
                      "\u0085\u0085unforgivable","\u0085\u0085well",
                      "\u0085allow","\u0085and","\u0085bloodi","\u0085bought",
                      "\u0085cantillon\u0092","\u0085cheer","\u0085chocolate",
                      "\u0085crisp","\u0085eh","\u0085hazi","\u0085heck",
                      "\u0085hey","\u0085holsten\u0085follow","\u0085hop",
                      "\u0085hops","\u0085howev","\u0092\u0085i",
                      "\u0085i\u0092m","\u0085leav","\u0085ltsighgt",
                      "\u0085mayb","\u0085must","\u0094\u0085now","\u0085the",
                      "\u0085\u0094the","\u0085though","\u0085to","\u0085twice",
                      "\u0085um\u0085root","\u0085umm","\u0085wow\u0085","   ", "    ")

style_terms <- c("ipa", "dipa", "double", "berliner", "weisse", "stout", 
                          "porter", "lager", "pilsner", "ale", "eisbock", "saison", "witbier", 
                          "hefeweizen", "geuze", "gruit", "tripel", "quadrupel", "barleywine", "neipa",
                          "gose", "wheat", "imperial", "session", "kolsch", "milk", 
                          "farmhouse", "lambic", "marzen", "oktoberfest", "braggot",
                          "dunkelweizen", "pilsner",  "flanders", "oud", "bruine", "rauchbier", "roggenbier",
                          "low_alcohol_beer", "sahti", "kvass", "kristallweizen", "ale", "brewed", "beer", "beers", "bier", "cerveza", "craft", "sud", "suds")

all_stopwords <- c(container_stopwords, style_terms, stopwords("en"))
all_stopwords <- all_stopwords[!all_stopwords %in% words_to_remove]
