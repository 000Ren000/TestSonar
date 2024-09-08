﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаВМоделиСервиса.РаботаСКлассификаторами".
// ОбщийМодуль.РаботаСКлассификаторамиСлужебныйВМоделиСервиса.
//
// Серверные процедуры и функции загрузки классификаторов из поставляемых данных:
//  - обработка дескрипторов поставляемых данных;
//  - загрузка не разделенных классификаторов;
//  - распространение по областям разделенных классификаторов;
//  - обработка данных классификаторов в областях;
//  - обработка событий Библиотеки технологии сервиса;
//  - обработки событий Библиотеки стандартных подсистем.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

#Область БСПОбновлениеИнформационнойБазы

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Выполняет перенос данных из кэша поставляемых данных в регистр сведений
// КэшДанныхКлассификаторов.
//
Процедура ПеренестиКэшДанныхКлассификаторов() Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Перенос кэша поставляемых данных в подсистему ""Работа с классификаторами"". Начало обновления.'"),
		Ложь);
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	Дескрипторы = МодульПоставляемыеДанные.ДескрипторыПоставляемыхДанныхИзКэша("Classifiers");
	
	Для Каждого Дескриптор Из Дескрипторы Цикл
		
		ДанныеФайла = МодульПоставляемыеДанные.ПоставляемыеДанныеИзКэша(
			Дескриптор.ИдентификаторФайла);
		
		// Если файла физически нет в кэше, невозможно его перенести
		// в кэш подсистемы "Работа с классификаторами".
		Если ДанныеФайла = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеФайла = РаботаСКлассификаторами.ОписаниеДанныхФайлаКлассификатора(
			ПоместитьВоВременноеХранилище(ДанныеФайла));
		
		Для Каждого Характеристика Из Дескриптор.Характеристики Цикл
			Если Характеристика.Код = "Идентификатор" Тогда
				ОписаниеФайла.Идентификатор = Характеристика.Значение;
			ИначеЕсли Характеристика.Код = "Версия" Тогда
				ОписаниеФайла.Версия = Число(Характеристика.Значение);
			ИначеЕсли Характеристика.Код = "КонтрольнаяСумма" Тогда
				ОписаниеФайла.КонтрольнаяСумма = Характеристика.Значение;
			ИначеЕсли Характеристика.Код = "ОписаниеВерсии" Тогда
				ОписаниеФайла.ОписаниеВерсии = Характеристика.Значение;
			ИначеЕсли Характеристика.Код = "Размер" Тогда
				ОписаниеФайла.Размер = Характеристика.Значение;
			КонецЕсли;
		КонецЦикла;
		
		// Не корректные данные кэша пропускаем.
		Если Не ЗначениеЗаполнено(ОписаниеФайла.Идентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		РаботаСКлассификаторами.ОбновитьКэшКлассификатора(ОписаниеФайла);
		
	КонецЦикла;
	
	// При работе в модели сервиса файлы классификаторов кэшировались в поставляемых
	// данных. При переходе на версию 2.4.1.10 кэш перенесен в регистр сведений
	// "КэшДанныхКлассификаторов". Устаревшие данные будут удалены через очередь заданий.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода", "УдалитьКэшПоставляемыхКлассификаторов");
	ПараметрыЗадания.Вставить("ОбластьДанных", -1);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяУниверсальнаяДата());
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Перенос кэша поставляемых данных в подсистему ""Работа с классификаторами"". Успешно завершено.'"),
		Ложь);
	
КонецПроцедуры

// При работе в модели сервиса файлы классификаторов кэшируются в поставляемых
// данных, поэтому для удаленных классификаторов необходимо удалить кэш.
//
// Параметры:
//  Идентификаторы - Массив - содержит фильтр, который используется для
//              отбора поставляемых данных.
//
Процедура УдалитьКэшПоставляемыхКлассификаторов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	Дескрипторы = МодульПоставляемыеДанные.ДескрипторыПоставляемыхДанныхИзКэша("Classifiers");
		
	Для Каждого Дескриптор Из Дескрипторы Цикл
		МодульПоставляемыеДанные.УдалитьПоставляемыеДанныеИзКэша(
			Дескриптор.ИдентификаторФайла);
	КонецЦикла;
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Удален кэш поставляемых данных классификаторов при
			|переходе на версию БИП 2.4.1.10.'"),
		Ложь);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область ИнтеграцияСБиблиотекойТехнологииСервиса

#Область БТСПоставляемыеДанные

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению,
//  и если ДА - установить флажок Загружать.
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое.
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	ВидДанных = Дескриптор.DataType;
	Если СтрНайти(ВидДанных, РаботаСКлассификаторами.ВидПоставляемыхДанныхКлассификаторы()) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Идентификатор = "";
	Версия        = "";
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "Идентификатор" Тогда
			Идентификатор = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "Версия" Тогда
			Версия = Число(Характеристика.Value);
		КонецЕсли;
	КонецЦикла;
	
	// Классификатор будет загружен, если в сервис были опубликованы новые данные.
	Настройки = РаботаСКлассификаторами.НастройкиКлассификатора(Идентификатор);
	Загружать = Настройки <> Неопределено;
	
	Если Не Загружать Тогда
		Возврат;
	КонецЕсли;
	
	// Начальное заполнение номера версии,
	// для новых классификаторов.
	Если Настройки.Версия = 0 Тогда
		Настройки.Версия = РаботаСКлассификаторами.ОбработатьНачальнуюВерсиюКлассификатора(Идентификатор);
	КонецЕсли;
	
	Загружать = (Настройки <> Неопределено
		И Настройки.Версия < Версия);
	
	Если Не Загружать Тогда
		Возврат;
	КонецЕсли;
	
	// Для классификаторов, которые не обновляются автоматический,
	// файлы сохраняются в кэше подсистемы "Работа с классификаторами",
	// поэтому перед загрузкой будет проверен номер версии в кэше
	// Проверка необходима для оптимизации загрузки поставляемых файлов,
	// т.к. после обновления конфигурации поставляемые данные будут
	// запрошены из Менеджера сервиса. Если не выполнять проверку,
	// файлы будут загружены повторно, что отрицательно скажется на
	// производительности системы.
	Если Не Настройки.ОбновлятьАвтоматически Тогда
		ВерсияКэш = РаботаСКлассификаторами.ВерсияКлассификатораКэш(Идентификатор);
		Если ВерсияКэш >= Версия Тогда
			Загружать = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	ВидДанных = Дескриптор.DataType;
	Если СтрНайти(ВидДанных, РаботаСКлассификаторами.ВидПоставляемыхДанныхКлассификаторы()) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеФайла = РаботаСКлассификаторами.ОписаниеДанныхФайлаКлассификатора(
		ПоместитьВоВременноеХранилище(
			Новый ДвоичныеДанные(ПутьКФайлу)));
	
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "Идентификатор" Тогда
			ОписаниеФайла.Идентификатор = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "Версия" Тогда
			ОписаниеФайла.Версия = Число(Характеристика.Value);
		ИначеЕсли Характеристика.Code = "КонтрольнаяСумма" Тогда
			ОписаниеФайла.КонтрольнаяСумма = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "ОписаниеВерсии" Тогда
			ОписаниеФайла.ОписаниеВерсии = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "Размер" Тогда
			ОписаниеФайла.Размер = Характеристика.Value;
		КонецЕсли;
	КонецЦикла;
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	Настройки = РаботаСКлассификаторами.НастройкиКлассификатора(ОписаниеФайла.Идентификатор);
	
	// Обновление будет выполняется интерактивно пользователем.
	Если Не Настройки.ОбновлятьАвтоматически Тогда
		РаботаСКлассификаторами.ОбновитьКэшКлассификатора(ОписаниеФайла);
		РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработка классификатора %1 не требуется, т.к. настройка ОбновлятьАвтоматически имеет значение Ложь
					|подробнее см. реализацию метода РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов
					|и ИнтеграцияПодсистемБИП.ПриДобавленииКлассификаторов.'"),
				ОписаниеФайла.Идентификатор),
			Ложь);
		Возврат;
	КонецЕсли;
	
	Если Настройки.СохранятьФайлВКэш
		Или Не Настройки.ОбщиеДанные Тогда
		РаботаСКлассификаторами.ОбновитьКэшКлассификатора(ОписаниеФайла);
		РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные классификатора %1 сохранены в кэше.'"),
				ОписаниеФайла.Идентификатор),
			Ложь);
	КонецЕсли;
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начало обработки Файл классификатора %1.'"),
			ОписаниеФайла.Идентификатор),
		Ложь);
	
	Если Настройки.ОбщиеДанные Тогда
		
		Обработан = Ложь;
		ДополнительныеПараметры = Новый Структура;
		
		РаботаСКлассификаторами.ПриЗагрузкеКлассификатора(
			ОписаниеФайла,
			Обработан,
			ДополнительныеПараметры);
		
		Если Обработан Тогда
			
			Если Настройки.ОбработкаРазделенныхДанных Тогда
				ОбновитьДанныеОбластей = Новый Массив;
				
				НастройкиКлассификатора = Новый Структура;
				НастройкиКлассификатора.Вставить("Идентификатор",           ОписаниеФайла.Идентификатор);
				НастройкиКлассификатора.Вставить("Версия",                  ОписаниеФайла.Версия);
				НастройкиКлассификатора.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
				ОбновитьДанныеОбластей.Добавить(НастройкиКлассификатора);
				
				ВыполнитьОбновлениеКлассификаторовВОбластяхДанных(
					ОбновитьДанныеОбластей,
					Дескриптор.FileGUID);
			КонецЕсли;
			
		Иначе
			
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать поставляемые данные классификатора:
					|Идентификатор: %1
					|Версия: %2'"),
				ОписаниеФайла.Идентификатор,
				ОписаниеФайла.Версия);
			
			РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(СообщениеОбОшибке);
			
		КонецЕсли;
	Иначе
		
		ОбластиДляОбновления = МодульПоставляемыеДанные.ОбластиТребующиеОбработки(
			Дескриптор.FileGUID,
			ВидДанных);
		
		ЗапланироватьРаспространениеКлассификатораПоОД(
			ОписаниеФайла,
			Дескриптор.FileGUID,
			ОбластиДляОбновления,
			ВидДанных);
		
		УстановитьПривилегированныйРежим(Истина);
		РаботаСКлассификаторами.УстановитьВерсиюКлассификатора(
			ОписаниеФайла.Идентификатор,
			ОписаниеФайла.Версия);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Завершена обработка файла классификатора %1.'"),
			ОписаниеФайла.Идентификатор),
		Ложь);
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	
	РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обработка поставляемых данных не выполнена.
				|Поставляемые данные:
				|%1'"),
			МодульПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)));
	
КонецПроцедуры

#КонецОбласти

#Область БТСОчередьЗаданий

// Выполняет обновление данных разделенного классификатора
// в области данных.
//
// Параметры:
//  ОписаниеФайла - Структура - см. функцию РаботаСКлассификаторами.ОписаниеДанныхФайлаКлассификатора;
//  ИдентификаторФайла   - УникальныйИдентификатор - файл обрабатываемого классификатора;
//  ОбластьДанных - Число - область данных информационной базы.
//  КодОбработчика - Строка - код обработчика.
//
Процедура ОбновлениеРазделенногоКлассификатора(
		ОписаниеФайла,
		ИдентификаторФайла,
		ОбластьДанных,
		КодОбработчика) Экспорт
	
	// Перед выполнением обновления данных необходимо восстановить файл
	// классификатора из кэша подсистемы.
	РезультатПолученияКэша = РаботаСКлассификаторами.ЗагрузитьФайлКлассификатораИзКэша(
		ОписаниеФайла.Идентификатор);
	Если Не РезультатПолученияКэша.Ошибка Тогда
		ОписаниеФайла.АдресФайла = РезультатПолученияКэша.АдресФайла;
	Иначе
		ВызватьИсключение РезультатПолученияКэша.СообщениеОбОшибке;
	КонецЕсли;
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	НастройкиВерсия = РаботаСКлассификаторами.ВерсияКлассификатора(
		ОписаниеФайла.Идентификатор);
	
	Если НастройкиВерсия = Неопределено Тогда
		НастройкиВерсия = 0;
	КонецЕсли;
	
	// Начальное заполнение номера версии,
	// для новых классификаторов.
	Если НастройкиВерсия = 0 Тогда
		НастройкиВерсия = РаботаСКлассификаторами.ОбработатьНачальнуюВерсиюКлассификатора(
			ОписаниеФайла.Идентификатор);
	КонецЕсли;
	
	// Если актуальная версия классификатора уже загружена в область,
	// повторная загрузка не требуется.
	Если НастройкиВерсия >= Число(ОписаниеФайла.Версия) Тогда
		МодульПоставляемыеДанные.ОбластьОбработана(
			ИдентификаторФайла,
			КодОбработчика,
			ОбластьДанных);
		Возврат;
	КонецЕсли;
	
	Попытка
		
		Обработан = Ложь;
		РаботаСКлассификаторами.ПриЗагрузкеКлассификатора(
			ОписаниеФайла,
			Обработан,
			Новый Структура);
		
		Если ТранзакцияАктивна() Тогда
			
			Пока ТранзакцияАктивна() Цикл
				ОтменитьТранзакцию(); // АПК:325 Отмена незакрытых транзакций.
			КонецЦикла;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По завершении выполнения обработчика ПриЗагрузкеКлассификатора классификатора %1 не была закрыта транзакция.'"),
				ОписаниеФайла.Идентификатор);
			РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
				ТекстСообщения,
				Истина);
			
		КонецЕсли;
		
		Если Обработан Тогда
			МодульПоставляемыеДанные.ОбластьОбработана(
				ИдентификаторФайла,
				КодОбработчика,
				ОбластьДанных);
		Иначе
			
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать поставляемые данные классификатора:
					|Идентификатор: %1
					|Версия: %2
					|Область данных: %3'"),
				ОписаниеФайла.Идентификатор,
				ОписаниеФайла.Версия,
				ОбластьДанных);
			
			РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
				СообщениеОбОшибке,
				Истина);
			
			// Требуется повтор выполнения операции.
			ВызватьИсключение СообщениеОбОшибке;
			
		КонецЕсли;
		
	Исключение
		
		Пока ТранзакцияАктивна() Цикл
			ОтменитьТранзакцию();
		КонецЦикла;
		
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать поставляемые данные классификатора:
				|Идентификатор: %1
				|Версия: %2
				|Область данных: %3,
				|Подробная информация об ошибке:
				|В результате выполнения обработчика ПриЗагрузкеКлассификатора возникло исключение:
				|%4'"),
			ОписаниеФайла.Идентификатор,
			ОписаниеФайла.Версия,
			ОбластьДанных,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(СообщениеОбОшибке);
		
		// Требуется повтор выполнения операции.
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецПопытки;
	
КонецПроцедуры

// Выполняет дополнительную обработку разделенных данных классификатора
// после обновления данных классификатора.
//
// Параметры:
//  ОбновитьДанныеОбластей - Массив - содержит настройки обновления классификаторов:
//    *Идентификатор - Строка - идентификатор классификатора в сервисе;
//    *Версия - Число  - номер загруженной версии классификатора;
//    *ДополнительныеПараметры - Структура - дополнительные параметры обработки областей.
//  ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла поставляемых данных.
//  ОбластьДанных - Число - область данных информационной базы.
//  КодОбработчика - Строка - код обработчика.
//
Процедура ОбновлениеРазделенныхДанныхНеРазделенногоКлассификатора(
		ОбновитьДанныеОбластей,
		ИдентификаторФайла,
		ОбластьДанных,
		КодОбработчика) Экспорт
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	
	Для Каждого НастройкиКлассификатора Из ОбновитьДанныеОбластей Цикл
		
		Попытка
			
			ИнтеграцияПодсистемБИП.ПриОбработкеОбластиДанных(
				НастройкиКлассификатора.Идентификатор,
				НастройкиКлассификатора.Версия,
				НастройкиКлассификатора.ДополнительныеПараметры);
			
			РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОбработкеОбластиДанных(
				НастройкиКлассификатора.Идентификатор,
				НастройкиКлассификатора.Версия,
				НастройкиКлассификатора.ДополнительныеПараметры);
			
			Если ТранзакцияАктивна() Тогда
				
				Пока ТранзакцияАктивна() Цикл
					ОтменитьТранзакцию();
				КонецЦикла;
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'По завершении выполнения обработчика ПриОбработкеОбластиДанных классификатора %1 не была закрыта транзакция.'"),
					НастройкиКлассификатора.Идентификатор);
				РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
					ТекстСообщения,
					Истина);
				
			КонецЕсли;
			
		Исключение
		
			Пока ТранзакцияАктивна() Цикл
				ОтменитьТранзакцию();
			КонецЦикла;
			
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать разделенные данные классификатора:
					|Идентификатор: %1
					|Версия: %2
					|Область данных: %3,
					|Подробная информация об ошибке:
					|В результате выполнения обработчика ПриОбработкеОбластиДанных возникло исключение:
					|%4'"),
				НастройкиКлассификатора.Идентификатор,
				НастройкиКлассификатора.Версия,
				ОбластьДанных,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			РаботаСКлассификаторами.ЗаписатьИнформациюВЖурналРегистрации(
				СообщениеОбОшибке);
			
		КонецПопытки;
		
	КонецЦикла;
	
	МодульПоставляемыеДанные.ОбластьОбработана(
		ИдентификаторФайла,
		КодОбработчика,
		ОбластьДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ИнтеграцияПодсистемИнтернетПоддержкиПользователей

// Добавляет задание на обновление данных классификаторов в областях.
//
// Параметры:
//  НастройкиКлассификаторов - Массив - содержит настройки обновления классификаторов:
//    *Идентификатор - Строка - идентификатор классификатора в сервисе;
//    *Версия - Число  - номер загруженной версии классификатора;
//    *ДополнительныеПараметры - Структура - дополнительные параметры обработки областей.
//
Процедура ЗапланироватьОбновлениеДанныхОбластей(НастройкиКлассификаторов) Экспорт
	
	Если НастройкиКлассификаторов.Количество() > 0 Тогда
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(НастройкиКлассификаторов);
		ПараметрыМетода.Добавить(Новый УникальныйИдентификатор);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", "ВыполнитьОбновлениеКлассификаторовВОбластяхДанных");
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", -1);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяУниверсальнаяДата());
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		
		МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
		МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

// Создает задания для обработки данных классификаторов в областях.
//
// Параметры:
//  ОбновитьДанныеОбластей - Массив - содержит настройки обновления классификаторов:
//    *Идентификатор - Строка - идентификатор классификатора в сервисе;
//    *Версия - Число  - номер загруженной версии классификатора;
//    *ДополнительныеПараметры - Структура - дополнительные параметры обработки областей.
//  ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла поставляемых данных.
//
Процедура ВыполнитьОбновлениеКлассификаторовВОбластяхДанных(
		ОбновитьДанныеОбластей,
		ИдентификаторФайла) Экспорт
	
	МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	
	Для Каждого ОбновитьОбластьДанных Из ОбновитьДанныеОбластей Цикл
		
		КодОбработчика = РаботаСКлассификаторами.ВидПоставляемыхДанныхКлассификаторы(
			ОбновитьОбластьДанных.Идентификатор);
		
		ОбластиДляОбновления = МодульПоставляемыеДанные.ОбластиТребующиеОбработки(
			ИдентификаторФайла,
			КодОбработчика);
			
		Для Каждого ОбластьДанных Из ОбластиДляОбновления Цикл
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(ОбновитьДанныеОбластей);
			ПараметрыМетода.Добавить(ИдентификаторФайла);
			ПараметрыМетода.Добавить(ОбластьДанных);
			ПараметрыМетода.Добавить(КодОбработчика);
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ИмяМетода", "ОбновлениеРазделенныхДанныхНеРазделенногоКлассификатора");
			ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
			ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяУниверсальнаяДата());
			ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
			
			МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет идентификаторы классификаторов, которые в обязательном порядке должны
// быть включены в манифест конфигурации для Менеджера сервиса.
//
// Параметры:
//  Идентификаторы - Массив из Строка - идентификатор классификатора для добавления в манифест.
//
Процедура ДополнитьИдентификаторыКлассификаторов(Идентификаторы) Экспорт
	
	ИдентификаторыМоделиСервиса = Новый Массив;
	ИнтеграцияПодсистемБИП.ПриОпределенииИдентификаторовКлассификаторов(
		ИдентификаторыМоделиСервиса);
	РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОпределенииИдентификаторовКлассификаторов(
		ИдентификаторыМоделиСервиса);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
		Идентификаторы,
		ИдентификаторыМоделиСервиса,
		Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает задания на обновление классификаторов в областях
// данных информационной базы.
//
// Параметры:
//  ОписаниеФайла - Структура - см. функцию РаботаСКлассификаторами.ОписаниеДанныхФайлаКлассификатора;
//  ИдентификаторФайла   - УникальныйИдентификатор - файл обрабатываемого классификатора;
//  ОбластиДляОбновления - Массив с- содержит список кодов областей;
//  КодОбработчика       - Строка -  код обработчика.
//
Процедура ЗапланироватьРаспространениеКлассификатораПоОД(
		ОписаниеФайла,
		ИдентификаторФайла,
		ОбластиДляОбновления,
		КодОбработчика)
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	
	Для Каждого ОбластьДанных Из ОбластиДляОбновления Цикл
		
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(ОписаниеФайла);
		ПараметрыМетода.Добавить(ИдентификаторФайла);
		ПараметрыМетода.Добавить(ОбластьДанных);
		ПараметрыМетода.Добавить(КодОбработчика);
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", "ОбновлениеРазделенногоКлассификатора");
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяУниверсальнаяДата());
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		
		МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
