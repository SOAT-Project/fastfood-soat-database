-- Cargos
insert into roles (role_name)
values ('ADMIN'),
       ('EMPLOYEE');

-- Funcionários
insert into staff (name, email, cpf, is_active)
values  ('John Doe', 'john.doe@email.com', '12345678901', TRUE),
        ('Mark Doe', 'mark.doe@email.com', '12345678902', TRUE);

-- Cargos x Funcionários
insert into staff_roles (staff_id, role_id)
values  (1, 1), (2, 2);

-- Categorias
insert into product_categories (name)
values  ('Lanche'),
        ('Acompanhamento'),
        ('Bebida'),
        ('Sobremesa');

-- Produtos
insert into products (value, name, description, image_url, product_category_id)
values
    -- Lanche
    (15.00, 'Hambúrguer Clássico', 'Hambúrguer bovino com queijo, alface e tomate', 'https://exemplo.com/images/hamburguer.jpg', 1),
    (18.00, 'X-Bacon', 'Hambúrguer com queijo, bacon crocante e maionese especial', 'https://exemplo.com/images/xbacon.jpg', 1),
    (16.50, 'Cheeseburger', 'Hambúrguer com queijo cheddar e molho especial', 'https://exemplo.com/images/cheeseburger.jpg', 1),
    (14.00, 'Hot Dog', 'Cachorro quente com salsicha, ketchup e mostarda', 'https://exemplo.com/images/hotdog.jpg', 1),

    -- Acompanhamento
    ( 8.00, 'Batata Frita', 'Porção de batata frita crocante', 'https://exemplo.com/images/batatafrita.jpg', 2),
    ( 7.00, 'Anéis de Cebola', 'Porção de anéis de cebola empanados', 'https://exemplo.com/images/aneiscebola.jpg', 2),
    ( 9.00, 'Salada Verde', 'Mix de folhas verdes com molho especial', 'https://exemplo.com/images/saladaverde.jpg', 2),
    ( 10.00, 'Mandioca Frita', 'Porção de mandioca crocante com molho', 'https://exemplo.com/images/mandioca.jpg', 2),

    -- Bebida
    ( 5.00, 'Refrigerante Lata', 'Refrigerante gelado de 350ml', 'https://exemplo.com/images/refrigerante.jpg', 3),
    ( 7.00, 'Suco Natural', 'Suco natural de laranja 300ml', 'https://exemplo.com/images/suco.jpg', 3),
    ( 6.00, 'Água Mineral', 'Água mineral com e sem gás 500ml', 'https://exemplo.com/images/agua.jpg', 3),
    ( 8.00, 'Cerveja Long Neck', 'Cerveja gelada 355ml', 'https://exemplo.com/images/cerveja.jpg', 3),

    -- Sobremesa
    ( 12.00, 'Sorvete Casquinha', 'Casquinha de sorvete com cobertura de chocolate', 'https://exemplo.com/images/sorvete.jpg', 4),
    (15.00, 'Brownie com Sorvete', 'Brownie de chocolate quente com sorvete de baunilha', 'https://exemplo.com/images/brownie.jpg', 4),
    (10.00, 'Pudim', 'Pudim tradicional com calda de caramelo', 'https://exemplo.com/images/pudim.jpg', 4),
    (14.00, 'Torta de Limão', 'Torta gelada de limão com merengue', 'https://exemplo.com/images/tortalimao.jpg', 4);


