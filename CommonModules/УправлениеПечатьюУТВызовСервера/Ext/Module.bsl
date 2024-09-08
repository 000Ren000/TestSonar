﻿
#Область ПрограммныйИнтерфейс

#Область ЭтикеткиИЦенники

// Возвращает данные для печати этикеток или ценников,
//	получает эти данные из модулей менеджеров объектов печати.
//
// Параметры:
//	Идентификатор	- Строка - может принимать значения "Ценники" или "Этикетки";
//	ОбъектыПечати	- Массив - массив ссылок на объекты для печати, ссылки должны быть одного типа;
//	ДополнительныеПараметры	- Структура - параметры печати.
//
// Возвращаемое значение:
//	Строка	-	адрес структуры во временном хранилище, содержащей данные для печати.
//
Функция ДанныеДляПечатиЦенниковИЭтикеток(Идентификатор, ОбъектыПечати, ДополнительныеПараметры) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыПечати[0]);
	
	СоответствиеОбъектов = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(ОбъектыПечати);
	Если СоответствиеОбъектов.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Печать этикеток и ценников для нескольких видов документов не поддерживается'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Идентификатор = "Ценники" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЦенников(ОбъектыПечати);	
	ИначеЕсли Идентификатор = "Этикетки" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЭтикеток(ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

// Возвращает данные для печати этикеток складских ячеек
//
// Параметры:
//  Идентификатор	 - Строка - Идентификатор команды печати,
//  ОбъектыПечати	- Массив - массив ссылок СправочникСсылка.СкладскиеЯчейки.
// 
// Возвращаемое значение:
//   - Строка	-	адрес структуры во временном хранилище, содержащей данные для печати.
//
Функция ДанныеДляПечатиЭтикетокСкладскиеЯчейки(Идентификатор, ОбъектыПечати) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Владелец КАК Склад,
	|	СкладскиеЯчейки.Помещение
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В(&Ячейки)";
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 1 Тогда
		ТекстИсключения = НСтр("ru = 'Выделены ячейки разных складских территорий (помещений).
			|Одновременно можно печатать этикетки только по ячейкам, принадлежащим одной складской территории (помещению).'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Выборка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Ссылка КАК Ячейка
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В ИЕРАРХИИ(&Ячейки)
	|	И НЕ СкладскиеЯчейки.ПометкаУдаления
	|	И НЕ СкладскиеЯчейки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	СкладскиеЯчейки.Код";
	
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	ТаблицаЯчеек = Запрос.Выполнить().Выгрузить();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склад", 	  Выборка.Склад);
	СтруктураПараметров.Вставить("Помещение", Выборка.Помещение);
	СтруктураПараметров.Вставить("Ячейки",    ТаблицаЯчеек);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураПараметров);
	
КонецФункции

#КонецОбласти

// Возвращает данные для печати этикеток складских ячеек
//
// Параметры:
//  МассивОбъектов - Массив - массив ссылок документов.
//  ПараметрыПечати	- Структура - дополнительные параметры печати.
// 
Процедура ДанныеДляЗаписиСостоянийОригиналовПослеПечатиКомлпекта(МассивОбъектов, ПараметрыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		
		Для Каждого ДокументСсылка Из МассивОбъектов Цикл
			ТипПоСсылке = ОбщегоНазначения.ИмяТаблицыПоСсылке(ДокументСсылка);
			ТипПоСсылке =  Метаданные.НайтиПоПолномуИмени(ТипПоСсылке);
			
			КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
				ТипПоСсылке.ПолноеИмя(),
				МассивОбъектов, Неопределено);
				
			СписокПечати = Новый СписокЗначений;
			Для Каждого Макет Из КомплектПечатныхФорм Цикл
				Если Макет.Печатать Тогда
					СписокПечати.Добавить(Макет.Имя, Макет.Представление);
				КонецЕсли;
			КонецЦикла;
			
			ОбъектПечати = Новый СписокЗначений;
			ОбъектПечати.Добавить(ДокументСсылка);
			
			УчетОригиналовПервичныхДокументовВызовСервера.ЗаписатьСостоянияОригиналовПослеПечати(ОбъектПечати,СписокПечати);
		КонецЦикла;
				
	КонецЕсли;

	
КонецПроцедуры

#Область Инв3_Инв19

// Возвращает структуру параметров формирования ПФ ИНВ3 и ИНВ19. 
//
// Параметры:
//  МассивПересчетов - 	Массив - массив ссылок на документы "Пересчет товаров".
// 
// Возвращаемое значение:
//  Структура - структура параметров с ключами:
//		*Описи - Массив - массив инвентаризационных описей, в инвентаризационный период которых попадают пересчеты из МассивПересчетов
//		*Склады - Массив - массив складов из пересчетов МассивПересчетов
//		*ДатаНачала - Дата - минимальная дата начала инвентаризационного периода из всех полученных описей, 
//							если описи не найдены, то минимальная дата из всех пересчетов
//		*ДатаОкончания - Дата - максимальная дата окончания инвентаризационного периода из всех полученных описей, 
//							если описи не найдены, то максимальная дата из всех пересчетов
//		*Организации - Массив - массив организация из списка описей.
//
Функция ПолучитьПараметрыФормирования(МассивПересчетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивПересчетов", МассивПересчетов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПересчетТоваров.Ссылка КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(ПересчетТоваров.Дата, ДЕНЬ) КАК Дата,
	|	ПересчетТоваров.Склад
	|ПОМЕСТИТЬ СписокПересчетов
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	ПересчетТоваров.Ссылка В(&МассивПересчетов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИнвентаризационнаяОпись.Ссылка,
	|	ИнвентаризационнаяОпись.Организация,
	|	ИнвентаризационнаяОпись.ДатаНачала,
	|	ИнвентаризационнаяОпись.ДатаОкончания,
	|	ИнвентаризационнаяОпись.Склад
	|ПОМЕСТИТЬ СписокОписей
	|ИЗ
	|	Документ.ИнвентаризационнаяОпись КАК ИнвентаризационнаяОпись
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокПересчетов КАК ПересчетТоваров
	|		ПО (ПересчетТоваров.Склад = ИнвентаризационнаяОпись.Склад)
	|			И (ПересчетТоваров.Дата МЕЖДУ ИнвентаризационнаяОпись.ДатаНачала И ИнвентаризационнаяОпись.ДатаОкончания)
	|ГДЕ
	|	ИнвентаризационнаяОпись.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокОписей.Ссылка КАК Ссылка
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокПересчетов.Склад
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокОписей.ДатаНачала) КАК ДатаНачала,
	|	МАКСИМУМ(СписокОписей.ДатаОкончания) КАК ДатаОкончания
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокПересчетов.Дата) КАК ДатаНачала,
	|	МАКСИМУМ(СписокПересчетов.Дата) КАК ДатаОкончания
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокОписей.Организация
	|ИЗ
	|	СписокОписей КАК СписокОписей";
	Результат = Запрос.ВыполнитьПакет(); 
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Описи", Результат[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	ПараметрыФормирования.Вставить("Склады", Результат[3].Выгрузить().ВыгрузитьКолонку("Склад"));
	Выборка = Результат[4].Выбрать();
	Выборка.Следующий();
	ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
	ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	Если НЕ ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала) Тогда
		Выборка = Результат[5].Выбрать();
		Выборка.Следующий();
		ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
		ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	КонецЕсли;
	ПараметрыФормирования.Вставить("Организации", Результат[6].Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Возврат ПараметрыФормирования;
	
КонецФункции

#КонецОбласти

// Сортирует по Организации, Контрагенту переданный массив документов сверки
//
// Параметры:
//	МассивОбъектов - Массив из ДокументСсылка.СверкаВзаиморасчетов,ДокументСсылка.СверкаВзаиморасчетов2_5_11 - массив ссылок документов.
//
// Возвращаемое значение:
//	Массив из ДокументСсылка.СверкаВзаиморасчетов,ДокументСсылка.СверкаВзаиморасчетов2_5_11 - отсортированный по Организации, Контрагенту массив документов.
//
Функция СортироватьДокументыСверки(МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СверкаВзаиморасчетов.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(СверкаВзаиморасчетов.Организация) КАК ОрганизацияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(СверкаВзаиморасчетов.Контрагент) КАК КонтрагентПредставление
	|ИЗ
	|	Документ.СверкаВзаиморасчетов КАК СверкаВзаиморасчетов
	|ГДЕ
	|	СверкаВзаиморасчетов.Ссылка В(&ОбъектыНаПечать)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СверкаВзаиморасчетов2_5_11.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(СверкаВзаиморасчетов2_5_11.Организация),
	|	ПРЕДСТАВЛЕНИЕ(СверкаВзаиморасчетов2_5_11.Контрагент)
	|ИЗ
	|	Документ.СверкаВзаиморасчетов2_5_11 КАК СверкаВзаиморасчетов2_5_11
	|ГДЕ
	|	СверкаВзаиморасчетов2_5_11.Ссылка В(&ОбъектыНаПечать)";
	
	Запрос.УстановитьПараметр("ОбъектыНаПечать", МассивОбъектов);
	
	Результат = МассивОбъектов;
	Выборка = Запрос.Выполнить().Выгрузить();
	Если Выборка.Количество() > 0 Тогда
		Выборка.Сортировать("ОрганизацияПредставление,КонтрагентПредставление");
		Результат = Выборка.ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЭтикеткиИЦенники

// Данные для печати этикеток доставки.
// 
// Параметры:
//  Идентификатор - Строка - 
//  ОбъектыПечати - Массив
// 
// Возвращаемое значение:
//  Структура - Данные для печати этикеток доставки:
// * ДоставкаНаНашСклад - Булево -
// * ЕстьЭтикеткиДляПечати - Булево -
// * АдресВХранилище - Строка -
// * МассивЗаданийБезРаспоряжений - Массив -
Функция ДанныеДляПечатиЭтикетокДоставки(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки(ОбъектыПечати);
	
КонецФункции

// Данные для печати этикеток упаковочные листы.
// 
// Параметры:
//  ОбъектыПечати - Массив
// 
// Возвращаемое значение:
//  Структура - Данные для печати этикеток упаковочные листы:
// * ЕстьШаблонЭтикетки - Булево -
Функция ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати);
	
КонецФункции


#КонецОбласти

#КонецОбласти