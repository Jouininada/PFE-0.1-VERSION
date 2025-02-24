import { EntityHelper } from 'src/common/database/interfaces/database.entity.interface';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { PAYMENT_MODE } from '../../enums/expense-payment-mode.enum';
import { CurrencyEntity } from 'src/modules/currency/repositories/entities/currency.entity';
import { FirmEntity } from 'src/modules/firm/repositories/entities/firm.entity';
import { ExpensePaymentUploadEntity } from './expense-payment-file.entity';
import { ExpensePaymentInvoiceEntryEntity } from './expense-payment-invoice-entry.entity';

@Entity('expense_payment')
export class ExpensePaymentEntity extends EntityHelper {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'float', nullable: true })
  amountPaid: number;

  @Column({ type: 'float', nullable: true })
  fee: number;

  @Column({ type: 'float', nullable: true })
  convertionRate: number;

  @Column({ nullable: true })
  date: Date;

  @Column({ type: 'enum', enum: PAYMENT_MODE, nullable: true })
  mode: PAYMENT_MODE;

  @Column({ type: 'varchar', length: 1024, nullable: true })
  notes: string;

  @ManyToOne(() => CurrencyEntity)
  @JoinColumn({ name: 'currencyId' })
  currency: CurrencyEntity;

  @Column({ type: 'int', nullable: true })
  currencyId: number;

  @OneToMany(() => ExpensePaymentUploadEntity, (upload) => upload.expensePayment)
  uploads: ExpensePaymentUploadEntity[];

  @OneToMany(() => ExpensePaymentInvoiceEntryEntity, (expenseInvoice) => expenseInvoice.Expensepayment)
  invoices: ExpensePaymentInvoiceEntryEntity[];

  @ManyToOne(() => FirmEntity)
  @JoinColumn({ name: 'firmId' })
  firm: FirmEntity;

  @Column({ type: 'int', nullable: true })
  firmId: number;
}
