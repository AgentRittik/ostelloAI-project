import { Body, Controller, Get, Post } from '@nestjs/common';
import { BookService } from './book.service';
import {Book} from './data/book.dto';

@Controller('books')
export class BooksController {
    constructor(private bookService : BookService){

    }

    @Get("/findAll")
    getAllBooks(){
        return this.bookService.getAllBooksService();
    }

    @Post("/create")
    createBooks(@Body() book : Book): string{
        return this.bookService.addBookService(book);
    }
}
