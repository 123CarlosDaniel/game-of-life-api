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