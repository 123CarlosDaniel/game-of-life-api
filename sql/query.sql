-- Creation stored procedure v1
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


-- Creation stored procedure v2
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