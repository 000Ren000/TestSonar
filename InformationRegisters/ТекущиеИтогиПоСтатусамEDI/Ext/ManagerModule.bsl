﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Перерасчитывает все итоги в регистре
// 
Процедура РассчитатьВсеИтоги() Экспорт
	
	УдалитьВсеИтоги();
	
	ТипыДокументов = ДокументыEDI.МассивИдентификаторовДокументовЗакупкиИПродажи();
	Статусы        = ДокументыEDIКлиентСервер.МассивСтатусовНеАрхив();
	
	РассчитатьИтоги(ТипыДокументов, Статусы, Неопределено, Неопределено, Неопределено);
	
КонецПроцедуры

// Рассчитывает итоги по переданным массивам измерений.
// 
// Параметры:
// 	ТипыДокументов         - Массив - рассчитываемые типы документов.
// 	Статусы                - Массив - рассчитываемые статусы.
// 	Менеджеры              - Массив - рассчитываемые менеджеры.
// 	Организации            - Массив - рассчитываемые организации.
// 	СостоянияСоответствия  - Массив - рассчитываемые состояния соответствия.
//
Процедура РассчитатьИтоги(ТипыДокументов, Статусы, Менеджеры , Организации , СостоянияСоответствия)  Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ХэшСуммыТиповДокументовСтатусов = ДокументыEDI.МассивХэшСуммИдентификаторовТиповДокументовИСтатусов(ТипыДокументов, Статусы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СостоянияДокументовEDI.ТипДокумента                                КАК ТипДокумента,
	|	СостоянияДокументовEDI.ТекущийСтатус                               КАК Статус,
	|	СостоянияДокументовEDI.Менеджер                                    КАК Менеджер,
	|	СостоянияДокументовEDI.Организация                                 КАК Организация,
	|	СостоянияДокументовEDI.СостояниеПрикладногоОбъекта                 КАК СостояниеСоответствия,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СостоянияДокументовEDI.ИдентификаторВСервисе) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СостоянияДокументовEDI КАК СостоянияДокументовEDI
	|ГДЕ
	|	СостоянияДокументовEDI.ХэшТипаДокументаИСтатуса В(&ХэшСуммыТиповДокументовИСтатусов)
	|	И СостоянияДокументовEDI.Менеджер В (&Менеджеры)
	|	И СостоянияДокументовEDI.Организация В (&Организации)
	|	И СостоянияДокументовEDI.СостояниеПрикладногоОбъекта В (&СостоянияСоответствия)
	|
	|СГРУППИРОВАТЬ ПО
	|	СостоянияДокументовEDI.ТипДокумента,
	|	СостоянияДокументовEDI.ТекущийСтатус,
	|	СостоянияДокументовEDI.Менеджер,
	|	СостоянияДокументовEDI.Организация,
	|	СостоянияДокументовEDI.СостояниеПрикладногоОбъекта";
	
	Запрос.УстановитьПараметр("ХэшСуммыТиповДокументовИСтатусов", ХэшСуммыТиповДокументовСтатусов);
	Запрос.УстановитьПараметр("Менеджеры", Менеджеры);
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("СостоянияСоответствия", СостоянияСоответствия);
	
	Если Менеджеры = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И СостоянияДокументовEDI.Менеджер В (&Менеджеры)", "");
	КонецЕсли;
	
	Если Организации = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И СостоянияДокументовEDI.Организация В (&Организации)", "");
	КонецЕсли;
	
	Если СостоянияСоответствия = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И СостоянияДокументовEDI.СостояниеСоответствия В (&СостоянияСоответствия)", "");
	КонецЕсли;
		
	ТаблицаИтогов = Запрос.Выполнить().Выгрузить();
	
	Если Менеджеры = Неопределено 
		Или Организации = Неопределено
		Или СостоянияСоответствия = Неопределено Тогда
		
		Для Каждого СтрокаТаблицы Из ТаблицаИтогов Цикл
			
			ПараметрыЗаписи = ПараметрыЗаписи();
			ЗаполнитьЗначенияСвойств(ПараметрыЗаписи, СтрокаТаблицы);
			ВыполнитьЗаписьВРегистр(ПараметрыЗаписи);
			
		КонецЦикла;
		
	Иначе
		
		ТаблицаИтогов.Индексы.Добавить("ТипДокумента");
		ТаблицаИтогов.Индексы.Добавить("Статус");
		ТаблицаИтогов.Индексы.Добавить("Менеджер");
		ТаблицаИтогов.Индексы.Добавить("Организация");
		ТаблицаИтогов.Индексы.Добавить("СостояниеСоответствия");
		
		Для Каждого ТипДокумента Из ТипыДокументов Цикл
			
			Для Каждого Статус Из Статусы Цикл
				
				Для Каждого Менеджер Из Менеджеры Цикл
					
					Для Каждого Организация Из Организации Цикл
						
						Для Каждого СостояниеСоответствия Из СостоянияСоответствия Цикл
							
							ПараметрыЗаписи = ПараметрыЗаписи();
							ПараметрыЗаписи.ТипДокумента          = ТипДокумента;
							ПараметрыЗаписи.Статус                = Статус;
							ПараметрыЗаписи.Менеджер              = Менеджер;
							ПараметрыЗаписи.Организация           = Организация;
							ПараметрыЗаписи.СостояниеСоответствия = СостояниеСоответствия;
							
							ВыполнитьЗаписьВРегистрПоТаблицеИтогов(ТаблицаИтогов, ПараметрыЗаписи);
							
						КонецЦикла;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


// Конструктор структуры для последующей записи в регистр
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * КоличествоДокументов  - Число - количество документов для разреза измерений.
// * СостояниеСоответствия - ПеречислениеСсылка.СостоянияСоответствияПрикладногоОбъектаДокументуEDI - состояние соответствия прикладного объекта.
// * Организация           - ОпределяемыйТип.ОрганизацияEDI - организация.
// * Менеджер              - СправочникСсылка.Пользователи - менеджер.
// * ТипДокумента          - ПеречислениеСсылка.ТипыДокументовEDI - тип документа.
// * Статус                - ПеречислениеСсылка.СтатусыЗаказаEDI - статус EDI.
//
Функция ПараметрыЗаписи() Экспорт
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Статус",                Неопределено);
	ПараметрыЗаписи.Вставить("ТипДокумента",          Неопределено);
	ПараметрыЗаписи.Вставить("Менеджер",              Неопределено);
	ПараметрыЗаписи.Вставить("Организация",           Неопределено);
	ПараметрыЗаписи.Вставить("СостояниеСоответствия", Неопределено);
	ПараметрыЗаписи.Вставить("КоличествоДокументов",  0);
	
	Возврат ПараметрыЗаписи;
	
КонецФункции


// Удаляет все записи в регистре.
// 
Процедура УдалитьВсеИтоги() Экспорт
	
	НаборЗаписей = РегистрыСведений.ТекущиеИтогиПоСтатусамEDI.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр
// 
// Параметры:
// 	ПараметрыЗаписи - Структура - Описание:
// * КоличествоДокументов - Число - итог по разрезам измерений.
// * СостояниеСоответствия - ПеречислениеСсылка.СостоянияСоответствияПрикладногоОбъектаДокументуEDI - состояние соответствия прикладного объекта.
// * Организация           - ОпределяемыйТип.ОрганизацияEDI - организация.
// * Менеджер              - СправочникСсылка.Пользователи - менеджер.
// * ТипДокумента          - ПеречислениеСсылка.ТипыДокументовEDI - тип документа.
// * Статус                - ПеречислениеСсылка.СтатусыЗаказаEDI - статус EDI.
Процедура ВыполнитьЗаписьВРегистр(ПараметрыЗаписи) Экспорт
	
	НаборЗаписей = РегистрыСведений.ТекущиеИтогиПоСтатусамEDI.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Статус.Установить(ПараметрыЗаписи.Статус);
	НаборЗаписей.Отбор.ТипДокумента.Установить(ПараметрыЗаписи.ТипДокумента);
	НаборЗаписей.Отбор.Менеджер.Установить(ПараметрыЗаписи.Менеджер);
	НаборЗаписей.Отбор.Организация.Установить(ПараметрыЗаписи.Организация);
	НаборЗаписей.Отбор.СостояниеСоответствия.Установить(ПараметрыЗаписи.СостояниеСоответствия);
	
	ЗаписьНабора = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(ЗаписьНабора, ПараметрыЗаписи);
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры


// Подготавливает пустую структуру для расчета итогов
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * СостоянияСоответствия - Массив - для помещения различных состояний соответствия.
// * Организации           - Массив - для помещения различных организаций.
// * Менеджеры             - Массив - для помещения различных менеджеров.
// * Статусы               - Массив - для помещения различных статусов.
// * ТипыДокументов        - Массив - для помещения различных типов документов.
Функция МассивыДляРасчетаИтогов() Экспорт
	
	Массивы = Новый Структура;
	Массивы.Вставить("ТипыДокументов",        Новый Массив);
	Массивы.Вставить("Статусы",               Новый Массив);
	Массивы.Вставить("Менеджеры",             Новый Массив);
	Массивы.Вставить("Организации",           Новый Массив);
	Массивы.Вставить("СостоянияСоответствия", Новый Массив);
	
	Возврат Массивы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьЗаписьВРегистрПоТаблицеИтогов(ТаблицаИтогов, ПараметрыЗаписи);
	
	НаборЗаписей = РегистрыСведений.ТекущиеИтогиПоСтатусамEDI.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Статус.Установить(ПараметрыЗаписи.Статус);
	НаборЗаписей.Отбор.ТипДокумента.Установить(ПараметрыЗаписи.ТипДокумента);
	НаборЗаписей.Отбор.Менеджер.Установить(ПараметрыЗаписи.Менеджер);
	НаборЗаписей.Отбор.Организация.Установить(ПараметрыЗаписи.Организация);
	НаборЗаписей.Отбор.СостояниеСоответствия.Установить(ПараметрыЗаписи.СостояниеСоответствия);
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Статус",                ПараметрыЗаписи.Статус);
	ПараметрыПоиска.Вставить("ТипДокумента",          ПараметрыЗаписи.ТипДокумента);
	ПараметрыПоиска.Вставить("Менеджер",              ПараметрыЗаписи.Менеджер);
	ПараметрыПоиска.Вставить("Организация",           ПараметрыЗаписи.Организация);
	ПараметрыПоиска.Вставить("СостояниеСоответствия", ПараметрыЗаписи.СостояниеСоответствия);
	
	НайденныеСтроки = ТаблицаИтогов.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, НайденнаяСтрока);
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
