import { Module } from '@nestjs/common';
import { BookModule } from './books/book.module';

@Module({
  imports: [BookModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
