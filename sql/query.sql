--% CreationGetAll stored procedure v1
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_sp`(in page_number int, in per_page int, in sort_name varchar(4), out pages int)
BEGIN
	declare total_rows int default 0;
    select COUNT(*) into total_rows from creation;
    set pages = Pages(total_rows, per_page);
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.data, ',
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    'COUNT(r.id) as reaction_count, ',
    'JSON_ARRAYAGG( ',
        '    JSON_OBJECT( ',
        '        "comment_id", cm.id, ',
        '        "opinion", cm.opinion, ',
        '        "comment_owner_id", ucm.id, ',
        '		 "comment_owner_name", ucm.name, ',
        '		 "comment_owner_image", ucm.image, ',
        '        "comment_createdAt", cm.createdAt, ',
        '        "comment_updatedAt", cm.updatedAt ',
        '    ) ',
        ') AS comments ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
    'GROUP BY c.id, c.title, c.description, c.data, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));
    
    prepare stmt FROM @sql_query;
	execute stmt;
    DEALLOCATE PREPARE stmt;
END


--% Creation stored procedure v2
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_sp`(in page_number int, in per_page int, in sort_name varchar(4), out pages int)
BEGIN
	declare total_rows int default 0;
    select COUNT(*) into total_rows from creation;
    set pages = Pages(total_rows, per_page);
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    'COUNT(r.id) as reactions_count, ',
    'COUNT(cm.id) AS comments_count ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));
    
    prepare stmt FROM @sql_query;
	execute stmt;
    DEALLOCATE PREPARE stmt;
END

-- functions
--% LimitClause
CREATE DEFINER=`root`@`localhost` FUNCTION `LimitClause`(page_number int, per_page int) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	set @limit_clause = case 
    when per_page >= 1 THEN CONCAT(' LIMIT ', per_page, ' OFFSET ', (page_number - 1) * per_page) 
	ELSE ' '
    end;
    return @limit_clause;
END


--% OrderByClause
CREATE DEFINER=`root`@`localhost` FUNCTION `OrderByClause`(table_name varchar(255), column_name varchar(255),  sort_direction varchar(4)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	-- declare order_clause varchar(255);
    set @order_clause = case
		when lower(sort_direction) = 'asc' then concat(' order by ', table_name,'.', column_name, ' ASC')
        when lower(sort_direction) = 'desc' then concat(' order by ', table_name,'.', column_name, ' DESC')
        else ' '
	end;
RETURN @order_clause;
END

--% Pages
CREATE DEFINER=`root`@`localhost` FUNCTION `Pages`(total_pages int, per_page int) RETURNS int
    DETERMINISTIC
BEGIN
	set @pages = if(per_page >= 1, ceil(total_pages/per_page), 1);
	RETURN @pages;
END


-- % CreationGet Stored Procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `creation_get_sp`(in id varchar(191))
BEGIN
set @id = id;
set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    'COUNT(r.id) as reactions_count, ',
    'COUNT(cm.id) AS comments_count ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
	'WHERE c.id = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt USING @id; 
    DEALLOCATE PREPARE stmt;
END

-- % CreationsGetByOwner Stored Procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_by_owner_sp`(
 in id varchar(191) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci,
 in page_number int, 
 in per_page int, 
 in sort_name varchar(4),
 out pages int)
BEGIN
	declare total_rows int default 0;
    set @id = id;
    select COUNT(*) into total_rows from creation WHERE ownerId = id;
    set pages = Pages(total_rows, per_page);
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    'COUNT(r.id) as reactions_count, ',
    'COUNT(cm.id) AS comments_count ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'WHERE c.ownerId = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));

    prepare stmt FROM @sql_query;
	execute stmt USING @id;
    DEALLOCATE PREPARE stmt;
END


--% CreationsGetAll Stored Procedure v3
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_sp`(
 in userId varchar(191),
 in page_number int,
 in per_page int,
 in sort_name varchar(4), 
 out pages int)
BEGIN
	declare total_rows int default 0;
    
    declare is_user_provided boolean default false;
    if userId is not null then
		set is_user_provided = true;
	end if;
	
    select COUNT(*) into total_rows from creation;
    set pages = Pages(total_rows, per_page);
    set @userId = userId;
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    'COUNT(r.id) as reactions_count, ',
    'COUNT(cm.id) AS comments_count, ');
    if is_user_provided then
		set @sql_query = concat(@sql_query, ' EXISTS(SELECT 1 FROM reaction WHERE ownerId = "', userId, '" AND creationId = c.id) AS isReactionActive ');
	else
		set @sql_query = concat(@sql_query, ' FALSE as isReactionActive ');
	end if;
    set @sql_query = concat(
    @sql_query,
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));
    
    prepare stmt FROM @sql_query;
	execute stmt;
    DEALLOCATE PREPARE stmt;
END


-- % CreationsGetAll Stored Procedure v4
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_sp`(
 in userId varchar(191),
 in page_number int,
 in per_page int,
 in sort_name varchar(4), 
 out pages int)
BEGIN
	declare total_rows int default 0;
    
    declare is_user_provided boolean default false;
    if userId is not null then
		set is_user_provided = true;
	end if;
	
    select COUNT(*) into total_rows from creation;
    set pages = Pages(total_rows, per_page);
    set @userId = userId;
    
    set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
    '(select COUNT(cm.id) from comment cm where cm.creationId = c.id) AS comments_count, ');
    if is_user_provided then
		set @sql_query = concat(@sql_query, ' EXISTS(SELECT 1 FROM reaction WHERE ownerId = "', userId, '" AND creationId = c.id) AS isReactionActive ');
	else
		set @sql_query = concat(@sql_query, ' FALSE as isReactionActive ');
	end if;
    set @sql_query = concat(
    @sql_query,
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));
    
    prepare stmt FROM @sql_query;
	execute stmt;
    DEALLOCATE PREPARE stmt;
END

-- % CreationsGetById Stored Procedure v2

CREATE DEFINER=`root`@`localhost` PROCEDURE `creation_get_sp`(
in userId varchar(191),
in id varchar(191)
)
BEGIN
declare is_user_provided boolean default false;
	if userId is not null
	then set is_user_provided = true;
end if;
set @id = id;
set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
	'(select COUNT(cm.id) from comment cm where cm.creationId = c.id) as comments_count, ');
if is_user_provided 
then set @sql_query = concat(@sql_query, 'EXISTS(select 1 from reaction  where creationId = c.id and ownerId = "', userId, '" ) as isReactionActive, ');
else set @sql_query = concat(@sql_query, 'FALSE as isReactionActive, ');
end if;
set @sql_query =concat(
		@sql_query,
        'JSON_ARRAYAGG( ',
		'    JSON_OBJECT( ',
		'        "comment_id", cm.id, ',
		'        "comment_opinion", cm.opinion, ',
		'        "comment_owner_id", ucm.id, ',
		'		 "comment_owner_name", ucm.name, ',
		'		 "comment_owner_image", ucm.image, ',
		'        "comment_createdAt", cm.createdAt, ',
		'        "comment_updatedAt", cm.updatedAt ',
		'    ) ',
		') AS comments ',
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'LEFT JOIN user ucm ON cm.ownerId = ucm.id ',
	'WHERE c.id = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt USING @id; 
    DEALLOCATE PREPARE stmt;
END

-- % CreationsGetByOwner Stored Procedure v2
CREATE DEFINER=`root`@`localhost` PROCEDURE `creations_get_by_owner_sp`(
 in userId varchar(191),
 in id varchar(191) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci,
 in page_number int, 
 in per_page int, 
 in sort_name varchar(4),
 out pages int)
BEGIN
	declare total_rows int default 0;
    declare is_user_provided boolean default false;
    
    if userId is not null then
		set is_user_provided = true;
	end if;
    
    set @id = id;
    select COUNT(*) into total_rows from creation WHERE ownerId = id;
    set pages = Pages(total_rows, per_page);
    
set @sql_query = concat(
    'SELECT c.id as creation_id, ',
    'uc.id as owner_id, ',
    'uc.name as owner_name, ',
    'uc.image as owner_image, ',
    'c.title, ',
    'c.description, ', 
    'c.createdAt as creation_createdAt, ', 
    'c.updatedAt as creation_updatedAt, ',
    '(select COUNT(r.id) from reaction r where r.creationId = c.id) as reactions_count, ',
    '(select COUNT(cm.id) from comment cm where cm.creationId = c.id) AS comments_count, ');
if is_user_provided then
	set @sql_query = concat(@sql_query, ' EXISTS(SELECT 1 FROM reaction WHERE ownerId = "', userId, '" AND creationId = c.id) AS isReactionActive ');
else
	set @sql_query = concat(@sql_query, ' FALSE as isReactionActive ');
end if;
set @sql_query = concat(
	@sql_query,
    ' FROM creation c ',
    'LEFT JOIN comment cm ON c.id = cm.creationId ',
    'LEFT JOIN reaction r ON c.id = r.creationId ', 
    'LEFT JOIN user uc ON c.ownerId = uc.id ',
    'WHERE c.ownerId = ? ',
    'GROUP BY c.id, c.title, c.description, c.createdAt, c.updatedAt ',
	OrderByClause('c','updatedAt', sort_name),
    LimitClause(page_number, per_page));

    prepare stmt FROM @sql_query;
	execute stmt USING @id;
    DEALLOCATE PREPARE stmt;
END