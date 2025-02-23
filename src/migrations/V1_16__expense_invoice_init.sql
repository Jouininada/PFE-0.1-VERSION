CREATE TABLE IF NOT EXISTS `expense_invoice_meta_data` (
    `id` int NOT NULL AUTO_INCREMENT,
    `showInvoiceAddress` boolean DEFAULT TRUE,
    `showDeliveryAddress` boolean DEFAULT TRUE,
    `showArticleDescription` boolean DEFAULT TRUE,
    `hasBankingDetails` boolean DEFAULT TRUE,
    `hasGeneralConditions` boolean DEFAULT TRUE,
    `taxSummary` json DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT NOW(),
    `updatedAt` TIMESTAMP DEFAULT NOW(),
    `deletedAt` TIMESTAMP DEFAULT NULL,
    `isDeletionRestricted` BOOLEAN DEFAULT FALSE,
    `hasTaxWithholding` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `expense_invoice` (
    `id` int NOT NULL AUTO_INCREMENT,
    `sequential` varchar(25) NOT NULL UNIQUE,
    `date` datetime DEFAULT NULL,
    `dueDate` datetime DEFAULT NULL,
    `object` varchar(255) DEFAULT NULL,
    `generalConditions` varchar(1024) DEFAULT NULL,
    `status` enum (
        'expense_invoice.status.non_existent',
        'expense_invoice.status.draft',
        'expense_invoice.status.sent',
        'expense_invoice.status.validated',
        'expense_invoice.status.paid',
        'expense_invoice.status.unpaid',
        'expense_invoice.status.expired',
        'expense_invoice.status.archived'
    ) DEFAULT NULL,
    `discount` float DEFAULT NULL,
    `discount_type` enum ('PERCENTAGE', 'AMOUNT') DEFAULT NULL,
    `subTotal` float DEFAULT NULL,
    `total` float DEFAULT NULL,
    `currencyId` int NOT NULL,
    `firmId` int NOT NULL,
    `interlocutorId` int NOT NULL,
    `cabinetId` int NOT NULL,
    `expenseInvoiceMetaDataId` int NOT NULL,
    `notes` varchar(1024) DEFAULT NULL,
    `bankAccountId` int DEFAULT NULL,
    `amountPaid` float DEFAULT NULL,
    `taxWithholdingId` INT DEFAULT NULL,
    `taxWithholdingAmount` FLOAT DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT NOW(),
    `updatedAt` TIMESTAMP DEFAULT NOW(),
    `deletedAt` TIMESTAMP DEFAULT NULL,
    `isDeletionRestricted` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`),
    KEY `FK_currency_expense_invoice` (`currencyId`),
    KEY `FK_firm_expense_invoice` (`firmId`),
    KEY `FK_interlocutor_expense_invoice` (`interlocutorId`),
    KEY `FK_cabinet_expense_invoice` (`cabinetId`),
    KEY `FK_expense_invoice_meta_data` (`expenseInvoiceMetaDataId`),
    KEY `FK_expense_invoice_tax_withholding` (`taxWithholdingId`),
    CONSTRAINT `FK_currency_expense_invoice` FOREIGN KEY (`currencyId`) REFERENCES `currency` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_firm_expense_invoice` FOREIGN KEY (`firmId`) REFERENCES `firm` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_interlocutor_expense_invoice` FOREIGN KEY (`interlocutorId`) REFERENCES `interlocutor` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_cabinet_expense_invoice` FOREIGN KEY (`cabinetId`) REFERENCES `cabinet` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_bank_account_expense_invoice` FOREIGN KEY (`bankAccountId`) REFERENCES `bank_account` (`id`) ON DELETE SET NULL,
    CONSTRAINT `FK_expense_invoice_meta_data` FOREIGN KEY (`expenseInvoiceMetaDataId`) REFERENCES `expense_invoice_meta_data` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_expense_invoice_tax_withholding` FOREIGN KEY (`taxWithholdingId`) REFERENCES `tax-withholding` (`id`) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS `article-expense-invoice-entry` (
    `id` int NOT NULL AUTO_INCREMENT,
    `unit_price` float DEFAULT NULL,
    `quantity` float DEFAULT NULL,
    `discount` float DEFAULT NULL,
    `discount_type` enum ('PERCENTAGE', 'AMOUNT') DEFAULT NULL,
    `subTotal` float DEFAULT NULL,
    `total` float DEFAULT NULL,
    `articleId` int DEFAULT NULL,
    `expenseInvoiceId` int DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT NOW(),
    `updatedAt` TIMESTAMP DEFAULT NOW(),
    `deletedAt` TIMESTAMP DEFAULT NULL,
    `isDeletionRestricted` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`),
    KEY `FK_article_article-expense-invoice-entry` (`articleId`),
    KEY `FK_expense_invoice_article-expense-invoice-entry` (`expenseInvoiceId`),
    CONSTRAINT `FK_article_article-expense-invoice-entry` FOREIGN KEY (`articleId`) REFERENCES `article` (`id`) ON DELETE SET NULL,
    CONSTRAINT `FK_expense_invoice_article-expense-invoice-entry` FOREIGN KEY (`expenseInvoiceId`) REFERENCES `expense_invoice` (`id`) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS `article-expense-invoice-entry-tax` (
    `id` int NOT NULL AUTO_INCREMENT,
    `articleExpenseInvoiceEntryId` int NOT NULL,
    `taxId` int NOT NULL,
    `createdAt` TIMESTAMP DEFAULT NOW(),
    `updatedAt` TIMESTAMP DEFAULT NOW(),
    `deletedAt` TIMESTAMP DEFAULT NULL,
    `isDeletionRestricted` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`),
    KEY `FK_articleExpenseInvoiceEntry_article-expense-invoice-entry-tax` (`articleExpenseInvoiceEntryId`),
    KEY `FK_tax_article-expense-invoice-entry-tax` (`taxId`),
    CONSTRAINT `FK_articleExpenseInvoiceEntry_article-expense-invoice-entry-tax` FOREIGN KEY (`articleExpenseInvoiceEntryId`) REFERENCES `article-expense-invoice-entry` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_tax_article-expense-invoice-entry-tax` FOREIGN KEY (`taxId`) REFERENCES `tax` (`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `expense_invoice_upload` (
    `id` int NOT NULL AUTO_INCREMENT,
    `expenseInvoiceId` int DEFAULT NULL,
    `uploadId` int DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT NOW(),
    `updatedAt` TIMESTAMP DEFAULT NOW(),
    `deletedAt` TIMESTAMP DEFAULT NULL,
    `isDeletionRestricted` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`),
    KEY `FK_expense_invoice_expense_invoice_upload` (`expenseInvoiceId`),
    KEY `FK_upload_expense_invoice_upload` (`uploadId`),
    CONSTRAINT `FK_expense_invoice_expense_invoice_upload` FOREIGN KEY (`expenseInvoiceId`) REFERENCES `expense_invoice` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_upload_expense_invoice_upload` FOREIGN KEY (`uploadId`) REFERENCES `upload` (`id`) ON DELETE CASCADE
);
