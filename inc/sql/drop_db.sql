DROP FUNCTION IF EXISTS `GetAgency`;
DROP FUNCTION IF EXISTS `GetAgents`; 
DROP FUNCTION IF EXISTS `GetAncestry`;
DROP FUNCTION IF EXISTS `GetChildrenByID`;
DROP FUNCTION IF EXISTS `GetParents`;
DROP FUNCTION IF EXISTS `GetSale`;

DROP TABLE `accounts`, `account_beneficiaries`, `account_meta`, `activity_logs`, `bank_accounts`, `commission_overriding`, `commission_personal`, `commission_scheme`, `commission_statements`, `email_queue`, `email_templates`, `files`, `file_categories`, `file_items`, `file_sub_categories`, `options`, `option_groups`, `payments`, `products`, `product_items`, `users`, `user_capabilities`, `user_capability_groups`, `user_levels`, `user_meta`;