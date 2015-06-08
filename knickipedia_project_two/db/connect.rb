require 'pg'

$db = PG.connect({
	dbname: 'knickipedia'
})