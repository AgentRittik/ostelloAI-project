import  {Module} from "@nestjs/common";
import { BookService } from "./book.service";
import { BooksController } from "./books.controller";

@Module({
    imports :[],
    controllers:[BooksController],
    providers:[BookService]
})
export class BookModule{}