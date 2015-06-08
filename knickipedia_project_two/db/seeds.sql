\c knickipedia;

-- create users
INSERT INTO users
  (name, email, password)
VALUES
  ('Jaden Carver', 'jaden@generalassemb.ly', 'blahblah'),
  ('Jeremy Bell', 'jeremyianbell@gmail.com', 'melville'),
  ('Phil Lamplugh', 'phil@generalassemb.ly', 'melville1')
  ;

-- create articles
INSERT INTO articles
  (user_id, name, content)
VALUES
  (1, 'Ruby', 'Lorem Ipsum'),
  (1, 'Sql', 'Lorem Ipsum'),
  (2, 'Javascript', 'Great Javascript article.'),
  (2, 'Jquery', 'Great Jquery article.'),
  (3, 'SQL', 'Best article on Sql ever.');
