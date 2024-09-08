﻿//@strict-types

#Область СлужебныеПроцедурыИФункции

#Область ДляВызоваИзМодуляРегламентыЭДО

// Возвращает состояние входящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеВходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоИсходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоИсходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗначениеЗаполнено(Состояние) Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние исходящего электронного документа.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияДокументовЭДО
//
Функция СостояниеИсходящегоДокумента(ПараметрыДокумента, СостоянияЭлементовРегламента) Экспорт
	
	Состояние = Перечисления.СостоянияДокументовЭДО.ПустаяСсылка();
	
	Если ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП, Неопределено, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗаполнитьСостояниеПоВходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
				
		ИЛИ ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолученииИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
		
		ИЛИ ЗначениеЗаполнено(Состояние) Тогда
		
		Возврат Состояние;
		
	ИначеЕсли ПараметрыДокумента.Исправлен Тогда
		
		Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершенСИсправлением;
		
	КонецЕсли;
	
	Возврат Перечисления.СостоянияДокументовЭДО.ОбменЗавершен;
	
КонецФункции

// Возвращает состояние сообщения.
//
// Параметры:
//  ПараметрыСообщения - См. РегламентыЭДО.НовыеПараметрыСообщенияДляОпределенияСостояния
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостоянияСообщения
//  ИспользоватьУтверждение  - Булево
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСообщенийЭДО
//
Функция СостояниеСообщения(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение) Экспорт
	
	Если ПараметрыСообщения.ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА Тогда
		Состояние = РегламентыЭДО.СостояниеСообщенияАннулирования(ПараметрыСообщения, ПараметрыДокумента);
	ИначеЕсли РегламентыЭДО.ЭтоСлужебноеСообщение(ПараметрыСообщения.ТипЭлементаРегламента) Тогда
		Состояние = РегламентыЭДО.СостояниеСлужебногоСообщения(ПараметрыСообщения, ПараметрыДокумента);
	Иначе
		Состояние = РегламентыЭДО.СостояниеСообщенияФНС(ПараметрыСообщения, ПараметрыДокумента, ИспользоватьУтверждение);
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Возвращает коллекцию добавленных элементов схемы регламента.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
Функция ДобавитьЭлементыСхемыРегламента(СхемаРегламента, НастройкиСхемыРегламента) Экспорт
	
	ЭлементыСхемы = РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
	Если НастройкиСхемыРегламента.ЭтоВходящийЭДО Тогда
		ДобавитьЭлементыРегламентаПолучателя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы);
	Иначе
		ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы);
	КонецЕсли;
	
	Возврат ЭлементыСхемы;
	
КонецФункции

// Параметры:
//  СхемаРегламента - см. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - см. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
// 
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
Функция ДобавитьЭлементыСхемыВложенногоРегламента(СхемаРегламента, НастройкиСхемыРегламента, ТипЭлементаРегламента) Экспорт
	
	Если ЭтоЭлементРегламентаАннулирования(ТипЭлементаРегламента) Тогда
		
		НовыеЭлементыСхемы = ДобавитьЭлементыРегламентаАннулирования(СхемаРегламента);
		
	ИначеЕсли ЭтоЭлементРегламентаОтклонения(ТипЭлементаРегламента) Тогда
		
		НовыеЭлементыСхемы = ДобавитьЭлементыРегламентаОтклонения(СхемаРегламента, НастройкиСхемыРегламента);
		
	Иначе
		
		НовыеЭлементыСхемы = РегламентыЭДО.ДобавитьПроизвольныйЭлементРегламента(СхемаРегламента, ТипЭлементаРегламента);
		
	КонецЕсли;
	
	Возврат НовыеЭлементыСхемы;
	
КонецФункции

// Возвращает тип извещения для элемента входящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаВходящегоДокумента(ТипЭлементаРегламента) Экспорт
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИОП;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает тип извещения для элемента исходящего документа.
// 
// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//
Функция ТипИзвещенияДляЭлементаИсходящегоДокумента(ТипЭлементаРегламента) Экспорт
	Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ПустаяСсылка();
	Если ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя Тогда
		Результат = Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ИОП;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает признак наличия информации получателя в регламенте.
// 
// Возвращаемое значение:
//  Булево
//
Функция ЕстьИнформацияПолучателя() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область СостояниеДокумента

// Возвращает признак успешности заполнения состояния по предложению об аннулировании.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоПредложениюОбАннулировании(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьАктуальноеАннулирование(СостоянияЭлементовРегламента, ЭлементРегламента) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	ОтклонениеПОА = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	Если РегламентыЭДО.ЕстьАктуальноеОтклонениеАннулирования(СостоянияЭлементовРегламента,
		ЭлементРегламента, ОтклонениеПОА) Тогда
		
		Если ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения;
			
		ИначеЕсли ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения;
			
		ИначеЕсли ОтклонениеПОА.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
			
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения;
			
		Иначе
			
			Результат = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, ОтклонениеПОА) Тогда
		
		// Отправитель запросил аннулирование документа, получатель - отклонил документ. 
		// Проверка состояния будет в ЗаполнитьСостояниеПоВходящемуОтклонению.
		Результат = Ложь;
	
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подтверждение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодтверждениеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаАннулирования;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ОжидаетсяПодпись Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеАннулирования;

	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Хранение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.Аннулирован;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему отклонению.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, ЭлементРегламента) Тогда
		
		Результат = Ложь;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеОтклонения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаОтклонения;
		
	ИначеЕсли Не ПараметрыДокумента.Исправлен Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ОжидаетсяИсправление;
		
	Иначе
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящей информации отправителя.
// 
// Параметры:
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящейИнформацииОтправителя(СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.НеПолучен;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Утверждение Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУтверждение;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящей информации получателя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Если Не ПараметрыДокумента.ТребуетсяПодтверждение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя, ЭлементРегламента) Тогда
		
		Если ПараметрыДокумента.ОбменБезПодписи Тогда
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		Иначе
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		КонецЕсли;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Если Не ПараметрыДокумента.ТребуетсяИзвещение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящемуИзвещениюОПолученииИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Если Не (ПараметрыДокумента.ТребуетсяИзвещение И РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя)) 
		Или ПараметрыДокумента.СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ИОП, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по подтверждению оператора.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Подтверждение - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  Извещение - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоПодтверждениюОператора(ПараметрыДокумента, СостоянияЭлементовРегламента, Подтверждение, Извещение, Состояние)
	
	Если Не РегламентыЭДО.ЭтоОбменЧерезОператора(ПараметрыДокумента.СпособОбмена) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента, Подтверждение, ЭлементРегламента) Тогда
		
		Результат = Ложь;
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние,
			Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждениеОператора);
		
	ИначеЕсли Не ЗначениеЗаполнено(Извещение) Тогда
		
		Результат = Ложь;
		
	ИначеЕсли Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента, Извещение, ЭлементРегламента) Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяИзвещениеОПолучении;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписаниеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправкеИзвещения;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда 
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправкаИзвещения;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по исходящей информации отправителя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоИсходящейИнформацииОтправителя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Истина;
	ЭлементРегламента = Неопределено; // Неопределено,СтрокаТаблицыЗначений: См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
	
	Если Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя, ЭлементРегламента) Тогда
		
		Состояние = РегламентыЭДО.НачальноеСостояниеДокумента();
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Подписание Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодписание;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.ПодготовкаКОтправке Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяПодготовкаКОтправке;
		
	ИначеЕсли ЭлементРегламента.Состояние = Перечисления.СостоянияСообщенийЭДО.Отправка Тогда
		
		Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяОтправка;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящему отклонению.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящемуОтклонению(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Ложь;
	
	Если РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ) Тогда
		
		Результат = Истина;
		
		Если ПараметрыДокумента.Исправлен Тогда
			Состояние = Перечисления.СостоянияДокументовЭДО.ЗакрытСОтклонением;
		Иначе
			Состояние = Перечисления.СостоянияДокументовЭДО.ТребуетсяУточнение;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящему извещению о получении.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящемуИзвещениюОПолучении(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Ложь;
	
	Если ПараметрыДокумента.ТребуетсяИзвещение
		И Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП) Тогда
		
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние, Перечисления.СостоянияДокументовЭДО.ОжидаетсяИзвещениеОПолучении);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак успешности заполнения состояния по входящей информации получателя.
// 
// Параметры:
//  ПараметрыДокумента - См. РегламентыЭДО.НовыеПараметрыДокументаДляОпределенияСостояния
//  СостоянияЭлементовРегламента - См. РегламентыЭДО.НовыеСостоянияЭлементовРегламента
//  Состояние - ПеречислениеСсылка.СостоянияДокументовЭДО
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполнитьСостояниеПоВходящейИнформацииПолучателя(ПараметрыДокумента, СостоянияЭлементовРегламента, Состояние)
	
	Результат = Ложь;
	
	Если ПараметрыДокумента.ТребуетсяПодтверждение
		И Не РегламентыЭДО.ЕстьЭлементРегламента(СостоянияЭлементовРегламента,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя) Тогда
		
		РегламентыЭДО.УстановитьПриоритетноеСостояние(Состояние, Перечисления.СостоянияДокументовЭДО.ОжидаетсяПодтверждение);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ДобавитьЭлементыСхемыРегламента

// Добавляет элементы по регламенту отправителя.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаОтправителя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы)
	
	ИнформацияОтправителя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
		
	ЭтоОбменЧерезОператора = РегламентыЭДО.ЭтоОбменЧерезОператора(НастройкиСхемыРегламента.СпособОбмена);

	Если ЭтоОбменЧерезОператора Тогда
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДП);
		
	КонецЕсли;
	
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП,
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение);
	
	ИнформацияПолучателя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя,
		Не НастройкиСхемыРегламента.ТребуетсяПодтверждение);
		
	Если ЭтоОбменЧерезОператора Тогда
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДО); 
		
	КонецЕсли;	
	
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ИОП, 
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение); 
		
КонецПроцедуры

// Добавляет элементы по регламенту получателя.
// 
// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//  НастройкиСхемыРегламента - См. РегламентыЭДО.НовыеНастройкиСхемыРегламента
//  ЭлементыСхемы - См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
//
Процедура ДобавитьЭлементыРегламентаПолучателя(СхемаРегламента, НастройкиСхемыРегламента, ЭлементыСхемы)
	
	ЭтоОбменЧерезОператора = РегламентыЭДО.ЭтоОбменЧерезОператора(НастройкиСхемыРегламента.СпособОбмена);

	ИнформацияОтправителя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
		
	Если ЭтоОбменЧерезОператора Тогда
		
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ПДО); 
		
	КонецЕсли;	

	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИОП,
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение);
	
	ИнформацияПолучателя = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя,
		Не НастройкиСхемыРегламента.ТребуетсяПодтверждение);
		
			
	Если ЭтоОбменЧерезОператора Тогда
			
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
			Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ПДП); 

	КонецЕсли;
		
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияПолучателя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияПолучателя_ИОП, 
		Не НастройкиСхемыРегламента.ТребуетсяИзвещение); 

КонецПроцедуры

// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
// 
// Возвращаемое значение:
//  Булево
Функция ЭтоЭлементРегламентаАннулирования(ТипЭлементаРегламента)
	Возврат ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА
		ИЛИ ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ;
КонецФункции

// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
Функция ДобавитьЭлементыРегламентаАннулирования(СхемаРегламента)
	
	ЭлементыСхемы = РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
	ИнформацияОтправителя = РегламентыЭДО.НайтиЭлементСхемыРегламента(СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
	Если ИнформацияОтправителя = Неопределено Тогда
		Возврат ЭлементыСхемы;
	КонецЕсли;
	
	ПОА = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА, Истина);
	
	РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ПОА,
		Перечисления.ТипыЭлементовРегламентаЭДО.ПОА_УОУ, Истина);
		
	Возврат ЭлементыСхемы;
	
КонецФункции

// Параметры:
//  ТипЭлементаРегламента - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО
// 
// Возвращаемое значение:
//  Булево
Функция ЭтоЭлементРегламентаОтклонения(ТипЭлементаРегламента)
	Возврат ТипЭлементаРегламента = Перечисления.ТипыЭлементовРегламентаЭДО.УОУ;
КонецФункции

// Параметры:
//  СхемаРегламента - См. РегламентыЭДО.НоваяСхемаРегламента
//
// Возвращаемое значение:
//  См. РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента
Функция ДобавитьЭлементыРегламентаОтклонения(СхемаРегламента, НастройкиСхемыРегламента)
	
	ЭлементыСхемы = РегламентыЭДО.НоваяКоллекцияЭлементовСхемыРегламента();
	
	ИнформацияОтправителя = РегламентыЭДО.НайтиЭлементСхемыРегламента(СхемаРегламента,
		Перечисления.ТипыЭлементовРегламентаЭДО.ИнформацияОтправителя);
	Если ИнформацияОтправителя = Неопределено Тогда
		Возврат ЭлементыСхемы;
	КонецЕсли;
	
	УОУ = РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, ИнформацияОтправителя,
		Перечисления.ТипыЭлементовРегламентаЭДО.УОУ, Истина);
		
	Если НастройкиСхемыРегламента.ЭтоВходящийЭДО Тогда
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, УОУ,
			Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ПДП);
	Иначе
		РегламентыЭДО.ВставитьЭлементСхемыРегламента(ЭлементыСхемы, УОУ,
			Перечисления.ТипыЭлементовРегламентаЭДО.УОУ_ПДО);
	КонецЕсли;

	Возврат ЭлементыСхемы;
	
КонецФункции

#КонецОбласти

#КонецОбласти