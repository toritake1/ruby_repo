#!/usr/local/bin/ruby
## -*- coding: utf-8 -*-

require "sparql/client"

require "sparql/client"
  
client = SPARQL::Client.new("http://ja.dbpedia.org/sparql")
results = client.query("
PREFIX dbpedia-owl:  <http://dbpedia.org/ontology/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX category-ja: <http://ja.dbpedia.org/resource/Category:>

select distinct ?pref where {
  ?pref dbpedia-owl:wikiPageWikiLink category-ja:日本の男性声優.
}
")

results.each do |solution|
#  puts "#{solution[:resource]} | #{solution[:title]}"
   puts "#{solution[:pref]}"
end

