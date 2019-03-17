//
//  Message_File.swift
//  File Me
//
//  Created by Lê Dũng on 3/13/19.
//

import UIKit

enum FileNotify : String
{
    case fileList           = "FileList"
    case fileCreate         = "FileCreate"
    case fileDelete         = "FileDelete"
}

//
//class FileList_Request : Mi {
//    
//}
//
//class FileCreate_Request : Mi {
//    
//}
//
//class FileDelete_Request : Mi {
//
//    
//}
//
//class FileOrder_Request : Mi {
//    
//}
//
//
//extension   MessageInstance {
//    
//    func fileRegister()
//    {
//        socket.on(FileNotify.fileList.rawValue) {data, ack in
//            notifyInstance.postM(.messageAfter, data)
//        }
//        socket.on(FileNotify.fileList.rawValue) {data, ack in
//            notifyInstance.postM(.messageAfter, data)
//        }
//        socket.on(FileNotify.fileList.rawValue) {data, ack in
//            notifyInstance.postM(.messageAfter, data)
//        }
//    }
//    
//    
//    func fileList(_ message : LimeMessage)
//    {
//        socket.emit(ConferenceNotify.messageDelivery.rawValue, with: [message.dictionary()])
//    }
//    
//    func fileCreate(_ message : LimeMessage)
//    {
//        socket.emit(ConferenceNotify.messageDelivery.rawValue, with: [message.dictionary()])
//    }
//    
//    func fileDelete(_ message : LimeMessage)
//    {
//        socket.emit(ConferenceNotify.messageDelivery.rawValue, with: [message.dictionary()])
//    }
//    
//    func fileOrder(_ message : LimeMessage)
//    {
//        socket.emit(ConferenceNotify.messageDelivery.rawValue, with: [message.dictionary()])
//    }
//
//}
