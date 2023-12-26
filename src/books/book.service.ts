import { Injectable } from '@nestjs/common';
import {Book} from './data/book.dto';

@Injectable()
export class BookService {
    public book : Book[] = [];

    //add books
    addBookService(book : Book) : string {
        this.book.push(book);
        return 'Book added successfully>>>';
    }
    //get all books
    getAllBooksService() : Book[] {
        return this.book;
    } 
}