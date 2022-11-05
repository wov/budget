//
//  CloudKitHelper.swift
//  IMS
//
//  Created by wov on 2021/3/20.
//


import Foundation
import CloudKit
import UIKit

struct CloudKitHelper {
    
    // MARK: - record types
    struct RecordType {
        static let Goods = "goods"
        static let inouts = "inouts"
        static let stores = "stores"
    }
    
//    var getedStore:CKRecord
//    struct MyVariables {
//        static var getedStore:CKRecord
//    }
    
    // MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    static func addSubscripion(){
        //        let container =  CKContainer.default()
        //        let db = container.CloudDatabase
        //        db.fetchAllSubscriptions { (subscriptions, error) in
        //            print(subscriptions)
        //        }
    }
    
//    static func saveAccount(account:Account , completion: @)
    
//
//    static func saveStore(store: Store,  completion: @escaping (Result<Store, Error>) -> ()){
//        let ckRecordZoneID = CKRecordZone(zoneName: "sharedZone")
//        let ckRecordID = CKRecord.ID(zoneID: ckRecordZoneID.zoneID)
//
//        let storeRecord = CKRecord(recordType: RecordType.stores, recordID: ckRecordID)
//
//        storeRecord["name"] = store.name as CKRecordValue
//        storeRecord["description"] = store.description as CKRecordValue
//        storeRecord["address"] = store.address as CKRecordValue
//
//        CKContainer.default().privateCloudDatabase.save(storeRecord){ (record , err) in
//
//            DispatchQueue.main.async {
//                if let err = err{
//                    completion(.failure(err))
//                    return
//                }
//                guard let record = record else{
//                    completion(.failure(CloudKitHelperError.recordFailure))
//                    return
//                }
//
//                guard let name = record["name"] as? String,
//                      let description = record["description"] as? String,
//                      let address = record["address"] as? String
//                else {
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    return
//                }
//
//                let store = Store(name: name, description: description, address: address)
//                completion(.success(store))
//            }
//        }
//    }
//
//
    
//
//    // MARK: - saving to CloudKit
//    static func save(good: Good,completion: @escaping (Result<Good, Error>) -> ()) {
//        //        let recordID = CKRecord.ID(zoneID: )
//        // Todo: need set parent root.
////        print(parentRecordID)
//
//        let ckRecordZoneID = CKRecordZone(zoneName: "sharedZone")
//        let ckRecordID = CKRecord.ID(zoneID: ckRecordZoneID.zoneID)
//
//
////        let parentRecord = CKRecord(recordType: RecordType.stores, recordID: parentRecordID)
//
//
//        let goodRecord = CKRecord(recordType: RecordType.Goods,recordID: ckRecordID)
//
//        //添加父级，用来分享
////        goodRecord.parent = CKRecord.Reference(record: parentRecord, action: .none)
////        goodRecord["store"] = CKRecord.Reference(record: parentRecord, action: .deleteSelf)
//
//
//        goodRecord["name"] = good.name as CKRecordValue
//        goodRecord["code"] = good.code as CKRecordValue
//
//        goodRecord["unit"] = good.unit as CKRecordValue
//        goodRecord["description"] = good.description as CKRecordValue
//
//        goodRecord["stock"] = NSNumber(value: good.stock) // good.stock as NSNumber
//
//        goodRecord["shelfNumber"] = good.shelfNumber as CKRecordValue
//        goodRecord["shelfPosition"] = good.shelfPosition as CKRecordValue
//
//        goodRecord["minimumStock"] = NSNumber(value: good.minimumStock)
//        goodRecord["days2Sell"] = NSNumber(value: good.days2Sell)
//
//
//
//        CKContainer.default().privateCloudDatabase.save(goodRecord) { (record, err) in
//            DispatchQueue.main.async {
//                if let err = err {
//                    completion(.failure(err))
//                    return
//                }
//                guard let record = record else {
//                    completion(.failure(CloudKitHelperError.recordFailure))
//                    return
//                }
//                let recordID = record.recordID
//                guard let name = record["name"] as? String ,
//                      let code = record["code"] as? String ,
//
//                      let description = record["description"] as? String ,
//                      let unit = record["unit"] as? String ,
//
//                      let stock = record["stock"] as? Float,
//                      let shelfNumber = record["shelfNumber"] as? String,
//                      let shelfPosition = record["shelfPosition"] as? String,
//                      let minimumStock = record["minimumStock"] as? Float,
//                      let days2Sell = record["days2Sell"] as? Int
//                else {
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    return
//                }
//
//                let good = Good(recordID: recordID,name: name, description: description, unit: unit,  stock: stock,  shelfNumber: shelfNumber, shelfPosition: shelfPosition,code:code, minimumStock:minimumStock ,days2Sell: days2Sell )
//                completion(.success(good))
//            }
//        }
//    }
//
//    //MARK: fetch store record form cloudkit
//    static func fetchStore(completion: @escaping (Result<Store?, Error>) -> ()) {
//        let pred = NSPredicate(value: true)
//        let query = CKQuery(recordType: RecordType.stores, predicate: pred)
//
//        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["name","address","description"]
//
//        operation.recordFetchedBlock = { record in
//            DispatchQueue.main.async {
//                print(record)
////                MyVariables.getedStore = record
//
//                let recordID = record.recordID
//                guard let name = record["name"] as? String,
//                      let address = record["address"] as? String,
//                      let description = record["description"] as? String
//                else{
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    return
//                }
//
//                let store = Store( recordID:recordID,name: name, description: description, address: address)
//                completion(.success(store))
//            }
//        }
//
//        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
//            DispatchQueue.main.async {
//                //                print("has query all the records")
//                if let err = err {
//                    completion(.failure(err))
//                    return
//                }
//                completion(.success(nil))
//            }
//
//        }
//
//        CKContainer.default().privateCloudDatabase.add(operation)
//
//
//    }
//
//    // MARK: - fetching from CloudKit
//    static func fetch(completion: @escaping (Result<Good?, Error>) -> ()) {
//
//        let pred = NSPredicate(value: true)
//        //        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
//        let query = CKQuery(recordType: RecordType.Goods, predicate: pred)
//        //        query.sortDescriptors = [sort]
//
//        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["name","unit","description","shelfNumber","shelfPosition","stock","code","minimumStock","days2Sell"]
//        //        operation.resultsLimit = 50
//
//        operation.recordFetchedBlock = { record in
//            DispatchQueue.main.async {
//                let recordID = record.recordID
//                guard let name = record["name"] as? String ,
//                      let code = record["code"] as? String ,
//
//                      let description = record["description"] as? String ,
//                      let unit = record["unit"] as? String ,
//
//                      let stock = record["stock"] as? Float,
//                      let shelfNumber = record["shelfNumber"] as? String,
//                      let shelfPosition = record["shelfPosition"] as? String,
//                      let minimumStock = record["minimumStock"] as? Float,
//                      let days2Sell = record["days2Sell"] as? Int
//                else {
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    return
//                }
//
//                let OTS: Bool = stock >= minimumStock ? false : true
//
//                let good = Good(recordID: recordID,name: name, description: description, unit: unit,  stock: stock,  shelfNumber: shelfNumber, shelfPosition: shelfPosition,code:code, minimumStock:minimumStock ,days2Sell: days2Sell , OTS: OTS )
//
//                completion(.success(good))
//            }
//        }
//
//        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
//            DispatchQueue.main.async {
//                //                print("has query all the records")
//                if let err = err {
//                    completion(.failure(err))
//                    return
//                }
//                completion(.success(nil))
//            }
//
//        }
//
//        CKContainer.default().privateCloudDatabase.add(operation)
//    }
//
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    //分享数据库
    
    static func shareStorage(){
        //        let ckRecordZoneID = CKRecordZone(zoneName: "sharedZone")
        //        let ckRecordID = CKRecord.ID(zoneID: ckRecordZoneID.zoneID)
        //
        //        let goodRecord = CKRecord(recordType: RecordType.Goods,recordID: ckRecordID)
        //        let share = CKShare(rootRecord:goodRecord)
        //        share.publicPermission = .readWrite
        //
        //
        //        let modifyRecordsOp = CKModifyRecordsOperation(recordsToSave: [share], recordIDsToDelete: nil)
        //
        //        let container  = CKContainer.default()
        //
        //        let sharingController = UICloudSharingController(share: share,container: container)
    }
    
    func addParticipant(  completion: @escaping (Result<[CKShare.Participant], Error>) -> Void){
        
        
        let ckRecordZoneID = CKRecordZone(zoneName: "sharedZone")
        let ckRecordID = CKRecord.ID(zoneID: ckRecordZoneID.zoneID)
        
        let goodRecord = CKRecord(recordType: RecordType.Goods,recordID: ckRecordID)
        let share = CKShare(rootRecord:goodRecord)
        share.publicPermission = .readWrite
                
        
        share[CKShare.SystemFieldKey.title] = "Equipo" as CKRecordValue?
        share[CKShare.SystemFieldKey.shareType] = "Some type" as CKRecordValue?
        
        
    }
    
//    
//    func fetchShareMetadata(for shareURLs: [URL],
//        completion: @escaping (Result<[URL: CKShare.Metadata], Error>) -> Void) {
//            
//        var cache = [URL: CKShare.Metadata]()
//            
//        // Create the fetch operation using the share URLs that
//        // the caller provides to the method.
//        let operation = CKFetchShareMetadataOperation(shareURLs: shareURLs)
//            
//        // Request that CloudKit includes the root record in
//        // the metadata it returns to reduce network requests.
//        operation.shouldFetchRootRecord = true
//            
//        // Cache the metadata that CloudKit returns using the
//        // share URL. This implementation ignores per-metadata
//        // fetch errors and handles any errors in the completion
//        // closure instead.
//        operation.perShareMetadataBlock = { url, metadata, _ in
//            guard let metadata = metadata else { return }
//            cache[url] = metadata
//        }
//            
//        // If the operation fails, return the error to the caller.
//        // Otherwise, return the array of participants.
//        operation.fetchShareMetadataCompletionBlock = { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(cache))
//            }
//        }
//            
//        // Set an appropriate QoS and add the operation to the
//        // container's queue to execute it.
//        operation.qualityOfService = .userInitiated
//        CKContainer.default().add(operation)
//    }
//
//    func fetchParticipants(for lookupInfos: [CKUserIdentity.LookupInfo],
//                           completion: @escaping (Result<[CKShare.Participant], Error>) -> Void) {
//
//        var participants = [CKShare.Participant]()
//
//        // Create the operation using the lookup objects
//        // that the caller provides to the method.
//        let operation = CKFetchShareParticipantsOperation(
//            userIdentityLookupInfos: lookupInfos)
//
//        // Collect the participants as CloudKit generates them.
//        operation.shareParticipantFetchedBlock = { participant in
//            participants.append(participant)
//        }
//
//        // If the operation fails, return the error to the caller.
//        // Otherwise, return the array of participants.
//        operation.fetchShareParticipantsCompletionBlock = { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(participants))
//            }
//        }
//
//        // Set an appropriate QoS and add the operation to the
//        // container's queue to execute it.
//        operation.qualityOfService = .userInitiated
//        CKContainer.default().add(operation)
//    }
    
    
    
    // 修改库存量
//    static func changeStock(good:Good , changeStock: Float, completion:  @escaping (Result<Good, Error>) -> ()){
//        guard let recordID = good.recordID else { return }
//        CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordID){ record,err in
//            if let err = err {
//                DispatchQueue.main.async {
//                    completion(.failure(err))
//                }
//                return
//            }
//
//            guard let record = record else {
//                DispatchQueue.main.async {
//                    completion(.failure(CloudKitHelperError.recordFailure))
//                }
//                return
//            }
//
//            record["stock"] = NSNumber(value: good.stock + changeStock)
//
//            CKContainer.default().privateCloudDatabase.save(record) { (record, err) in
//                DispatchQueue.main.async {
//                    if let err = err {
//                        completion(.failure(err))
//                        return
//                    }
//                    guard let record = record else {
//                        completion(.failure(CloudKitHelperError.recordFailure))
//                        return
//                    }
//                    guard let name = record["name"] as? String ,
//                          let code = record["code"] as? String ,
//
//                          let description = record["description"] as? String ,
//                          let unit = record["unit"] as? String ,
//
//                          let stock = record["stock"] as? Float,
//                          let shelfNumber = record["shelfNumber"] as? String,
//                          let shelfPosition = record["shelfPosition"] as? String,
//                          let minimumStock = record["minimumStock"] as? Float,
//                          let days2Sell = record["days2Sell"] as? Int
//                    else {
//                        completion(.failure(CloudKitHelperError.castFailure))
//                        return
//                    }
//
//                    let good = Good(recordID: recordID,name: name, description: description, unit: unit,  stock: stock,  shelfNumber: shelfNumber, shelfPosition: shelfPosition,code:code, minimumStock:minimumStock ,days2Sell: days2Sell )
//                    completion(.success(good))
//                }
//            }
//        }
//    }
}

