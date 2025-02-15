import { DISCOUNT_TYPES } from 'src/app/enums/discount-types.enum';
import { EntityHelper } from 'src/common/database/interfaces/database.entity.interface';
import { ArticleEntity } from 'src/modules/article/repositories/entities/article.entity';
import { ExpensQuotationEntity } from './expensquotation.entity';
import { Column, Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';

@Entity('expense_article_quotation_entry') // Match the table name in SQL
export class ArticleExpensQuotationEntryEntity extends EntityHelper {
  
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'float', nullable: true })
  unitPrice: number;

  @Column({ type: 'float', nullable: true })
  quantity: number;

  @Column({ type: 'float', nullable: true })
  discount: number;

  @Column({ type: 'enum', enum: DISCOUNT_TYPES, nullable: true })
  discountType: DISCOUNT_TYPES;

  @Column({ type: 'float', nullable: true })
  subTotal: number;

  @Column({ type: 'float', nullable: true })
  total: number;

  @Column({ type: 'int', nullable: true })
  articleId: number;
  
  @ManyToOne(() => ArticleEntity, { nullable: true })
  @JoinColumn({ name: 'articleId' })
  article: ArticleEntity;

  @ManyToOne(() => ExpensQuotationEntity, { nullable: true })
  @JoinColumn({ name: 'expenseQuotationId' })
  expenseQuotation: ExpensQuotationEntity;

  // Soft delete and timestamps inherited from EntityHelper
}
