﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройКлиентУТ.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормаПоискНоменклатурыПоШтрихкоду

// См. РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриОткрытии.
Процедура ПоискНоменклатурыПоШтрихкодуПриОткрытии(Форма) Экспорт
	
	#Если Не ВебКлиент Тогда
	Сигнал();
	#КонецЕсли
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, Форма, "СканерШтрихкода");
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуПриЗакрытии.
Процедура ПоискНоменклатурыПоШтрихкодуПриЗакрытии(Форма, ЗавершениеРаботы) Экспорт
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, Форма);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуОбработкаОповещения.
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ШтрихКоды) Экспорт

	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И Форма.ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(Форма, МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	// Конец ПодключаемоеОборудование
	ИначеЕсли ИмяСобытия = "РаботаСНоменклатурой_ПроставитьПризнакЗагрузки" Тогда
		Если Параметр.Свойство("СсылкаНаНовуюНоменклатуру") Тогда
			РаботаСНоменклатуройВызовСервераУТ.ЗаполнитьНоменклатуруПоШтрихкоду(Форма, Параметр.СсылкаНаНовуюНоменклатуру);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ПоискНоменклатурыПоШтрихкодуОбработкаВыбора.
Процедура ПоискНоменклатурыПоШтрихкодуОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	//++ Локализация
	Если Форма.ЕстьАлкогольнаяПродукция Тогда
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(
			Новый ОписаниеОповещения("ПриВыбореНоменклатуры", ЭтотОбъект, Форма), ВыбранноеЗначение, ИсточникВыбора);
			
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

// Процедура, вызываемая при изменении поля Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - форма поиска номенклатуры по штрихкоду.
//  Элемент	 - ПолеФормы - изменяемое поле формы.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураПриИзменении(Форма, Элемент) Экспорт
	
	Перем КэшированныеЗначения;
	ТекущиеДанные = Форма.Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущиеДанные.Упаковка);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// Процедура, вызываемая при создании в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураСоздание(Форма, Элемент, СтандартнаяОбработка) Экспорт
	//++ Локализация
	ТекущиеДанные = Форма.Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если Форма.ЕстьАлкогольнаяПродукция
		И ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.АлкогольнаяПродукция) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(
			ЭтотОбъект,
			ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
		
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

// Процедура, вызываемая при начале выбора в поле Номенклатура формы ПоискНоменклатурыПоШтрихкоду.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//  Элемент				 - ПолеФормы - элемент формы.
//  ДанныеВыбора		 - СписокЗначений - данные выбора..
//  СтандартнаяОбработка - Булево -  признак стандартной обработки.
//
Процедура ПоискНоменклатурыПоШтрихкодуНоменклатураНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	//++ Локализация
	ТекущиеДанные = Форма.Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если Форма.ЕстьАлкогольнаяПродукция
		И ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.АлкогольнаяПродукция) Тогда
		
		СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(
			Форма, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная"), СтандартнаяОбработка,,
			ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
		
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

// См. РаботаСНоменклатуройКлиентПереопределяемый.СоздатьНоменклатуруИнтерактивно.
Процедура СоздатьНоменклатуруИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт 
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.СоздатьВидНоменклатурыИнтерактивно.
Процедура СоздатьВидНоменклатурыИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт 
	
	ОткрытьФорму("Справочник.ВидыНоменклатуры.Форма.ФормаЭлемента", 
		ПараметрыФормы, , , , , ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуДополнительногоЗначения.
Процедура ОткрытьФормуДополнительногоЗначения(ПараметрыФормы, Форма) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец",     ПараметрыФормы.РеквизитСсылка);
	ЗначенияЗаполнения.Вставить("Наименование", ПараметрыФормы.Наименование);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.Форма.ФормаЭлемента", ПараметрыФормы, Форма);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуДополнительногоРеквизита.
Процедура ОткрытьФормуДополнительногоРеквизита(ПараметрыФормы, Форма) Экспорт
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ФормаЭлемента", ПараметрыФормы, Форма);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуНоменклатуры.
Процедура ОткрытьФормуНоменклатуры(НоменклатураСсылка, Форма) Экспорт
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", Новый Структура("Ключ", НоменклатураСсылка), Форма);
	
КонецПроцедуры
	
// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуВидаНоменклатуры.
Процедура ОткрытьФормуВидаНоменклатуры(ВидНоменклатурыСсылка, Форма) Экспорт
	
	ОткрытьФорму("Справочник.ВидыНоменклатуры.Форма.ФормаЭлемента", Новый Структура("Ключ", ВидНоменклатурыСсылка), Форма);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуСпискаВидаНоменклатуры.
Процедура ОткрытьФормуСпискаВидаНоменклатуры(ВидНоменклатурыСсылка, Форма, ОписаниеОповещенияОЗакрытии) Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Ссылка", ВидНоменклатурыСсылка));
	
	ОткрытьФорму("Справочник.ВидыНоменклатуры.Форма.ФормаСписка", ПараметрыФормы, Форма,,,,ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуСпискаНоменклатуры.
Процедура ОткрытьФормуСпискаНоменклатуры(НоменклатураСсылка, Форма) Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Ссылка", НоменклатураСсылка));
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСписка", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Обработчик оповещения выбора номенлатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - выбранное значение.
//  ДополнительныеПараметры - ФормаКлиентскогоПриложения - форма из обработчика события которой происходит вызов процедуры.
//
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Перем КэшированныеЗначения;
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ДополнительныеПараметры.Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Номенклатура = Номенклатура;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущиеДанные.Упаковка);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры.
Процедура ОткрытьФормуВыбораНоменклатуры(ПараметрыФормы, 
	Владелец = Неопределено,
	ОписаниеОповещенияОЗакрытии = Неопределено, 
	РежимОткрытияОкнаФормы = Неопределено) Экспорт
	
	КлючУникальности = Новый УникальныйИдентификатор;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Владелец, "УникальныйИдентификатор") Тогда
		КлючУникальности = Владелец.УникальныйИдентификатор;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораГруппИЭлементов", 
		ПараметрыФормы, Владелец, КлючУникальности,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы);
	
КонецПроцедуры

//++ Локализация

// См. РаботаСНоменклатуройКлиентПереопределяемый.ПоказатьНезаполненныеДанныеНоменклатуры.
Процедура ПоказатьНезаполненныеДанныеНоменклатуры(НоменклатураСсылка, НезаполненныеРеквизиты, Форма, ОписаниеОповещения) Экспорт
	
	ФормаЭлемента = ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", Новый Структура("Ключ", НоменклатураСсылка), Форма, 
		НоменклатураСсылка,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	ОчиститьСообщения();
	
	Если НезаполненныеРеквизиты.Количество() = 1 И НезаполненныеРеквизиты[0] = "Штрихкоды" Тогда
		ПараметрыОткрытия = Новый Структура("Отбор", Новый Структура("Номенклатура", НоменклатураСсылка));
		ФормаШтрихкоды = ОткрытьФорму("РегистрСведений.ШтрихкодыНоменклатуры.ФормаСписка", ПараметрыОткрытия,,, ФормаЭлемента.Окно,);
		ТекстСообщения = НСтр("ru = 'Номенклатура не имеет ни одного штрихкода'");
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Поле = "Список";
		СообщениеПользователю.Текст = ТекстСообщения;
		СообщениеПользователю.ИдентификаторНазначения = ФормаШтрихкоды.УникальныйИдентификатор;
		СообщениеПользователю.Сообщить();
	Иначе 
		СоответствиеЭлементовФормы = Новый Структура;
		СоответствиеЭлементовФормы.Вставить("Наименование",     "Объект.Наименование");
		СоответствиеЭлементовФормы.Вставить("ЕдиницаИзмерения", "Объект.ЕдиницаИзмерения");
		СоответствиеЭлементовФормы.Вставить("СтавкаНДС",        "Объект.СтавкаНДС");
		СоответствиеЭлементовФормы.Вставить("Артикул",          "Объект.Артикул");
		
		Если НезаполненныеРеквизиты.Найти("СтавкаНДС") <> Неопределено Тогда 
			ФормаЭлемента.Элементы["СворачиваемаяГруппаОсновныеПараметрыУчета"].Видимость = Истина;
		КонецЕсли;
		
		Если НезаполненныеРеквизиты.Найти("ЕдиницаИзмерения") <> Неопределено Тогда 
			ФормаЭлемента.Элементы["СворачиваемаяГруппаЕдиницыИзмерения"].Видимость = Истина;
		КонецЕсли;
		
		НетШтрихкода = Ложь;
		Для каждого Реквизит Из НезаполненныеРеквизиты Цикл
			Если СоответствиеЭлементовФормы.Свойство(Реквизит) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнено значение реквизита ""%1""'"), Реквизит);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, СоответствиеЭлементовФормы[Реквизит]);
			ИначеЕсли Реквизит = "Штрихкоды" Тогда
				НетШтрихкода = Истина;
			КонецЕсли;
		КонецЦикла;
		Если НетШтрихкода = Истина Тогда
			ТекстСообщения = НСтр("ru = 'Номенклатура не имеет ни одного штрихкода'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьШтрихкоды(Форма, ДанныеШтрихкодов)
	
	Для Каждого ЭлементДанных Из ДанныеШтрихкодов Цикл
		НайденныеСтроки = Форма.ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементДанных.Штрихкод));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].Количество = НайденныеСтроки[0].Количество + ЭлементДанных.Количество;
		Иначе

			Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(ДанныеШтрихкодов, Ложь) Тогда   
				ТекстОповещения = НСтр("ru = 'Эта форма не предназначена для работы с кодами маркировки.'");
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Ошибка чтения штрихкода'"),
					,
					ТекстОповещения,
					БиблиотекаКартинок.Предупреждение32);
				Возврат;
			КонецЕсли;     
			
			ДанныеШтрихкода = РаботаСНоменклатуройВызовСервераУТ.ПолучитьДанныеШтрихкода(ЭлементДанных.Штрихкод);
			Если ДанныеШтрихкода = Неопределено Тогда
				НовыйШтрихкод = Форма.ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
			Иначе
				
				НовыйШтрихкод = Форма.ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод   = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
				ЗаполнитьЗначенияСвойств(НовыйШтрихкод, ДанныеШтрихкода);
				НовыйШтрихкод.Зарегистрирован = Истина;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти