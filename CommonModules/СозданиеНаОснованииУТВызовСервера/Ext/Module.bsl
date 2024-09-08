﻿
#Область СлужебныеПроцедурыИФункции

#Область ЗаказыПоставщикам

Функция ПроверитьВозможностьВводаНаОсновании(ПараметрКоманды) Экспорт
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрКоманды,"Статус,Проведен");
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПараметрКоманды);
	МенеджерОбъекта.ПроверитьВозможностьВводаНаОсновании(
		ПараметрКоманды, СтруктураРеквизитов.Статус, НЕ СтруктураРеквизитов.Проведен, Истина);
	
КонецФункции

#КонецОбласти

#Область ДокументыНаОснованииЗаказа

// Формиирует параметры открытия формы накладной на основании заказа/распоряжений.
// 
// Параметры:
//  Распоряжения - Массив из ДокументСсылка- список распоряжений, на основании которых оформляется накладная.
//  ИмяНакладной - Строка - Тип документа, на осоновании которого формируется распоряжение.
//  ХозяйственнаяОперация - Неопределено, ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция
// 
// Возвращаемое значение:
//  Структура - Параметры открытия формы накладной на основании заказа
Функция ПараметрыОткрытияФормыНакладнойНаОснованииЗаказа(Распоряжения, ИмяНакладной, ХозяйственнаяОперация = Неопределено) Экспорт
	
	ДанныеДляПроверки = Документы[ИмяНакладной].ДанныеДляПроверкиВводаНаОсновании(Распоряжения, ХозяйственнаяОперация);
	ОткрытьФормуДокумента = Ложь;
	
	Если ЗначениеЗаполнено(ДанныеДляПроверки.Основание) Тогда
		
		// Проверка статуса
		ДопустимыеСтатусы = Документы[ДанныеДляПроверки.Основание.Метаданные().Имя].ДопустимыеСтатусыВводаНаОсновании(ИмяНакладной);
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДанныеДляПроверки.Основание, ДанныеДляПроверки.Статус, Ложь,
			ДопустимыеСтатусы.Найти(ДанныеДляПроверки.Статус) = Неопределено, ДопустимыеСтатусы);
			
		// Проверка действий
		Если Не ДанныеДляПроверки.ЕстьОтгрузить Тогда
			ВызватьИсключение ОбеспечениеВДокументахСервер.ТекстОшибкиНетТоваровДоступныхДляОтгрузки()
		КонецЕсли;
		
		ОткрытьФормуДокумента = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеДляПроверки.РаспоряженияКОформлению) Тогда
		ВызватьИсключение НСтр("ru='Нет свободных остатков к оформлению. Ввод на основании невозможен.'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеДляПроверки.Основание) И ДанныеДляПроверки.МожноСгруппировать Тогда
		РаспоряженияКГруппировке = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ДанныеДляПроверки.РаспоряженияКОформлению);
		НакладныеСервер.СгруппироватьДокументыПоКлючевымПолям(РаспоряженияКГруппировке,
			Документы[ИмяНакладной].КлючевыеПоляШапкиРаспоряжения());
		Если РаспоряженияКГруппировке.Количество() = 1 Тогда
			ОткрытьФормуДокумента = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	Если ОткрытьФормуДокумента Тогда
		
		ПараметрыЗаполнения = Документы[ИмяНакладной].ПараметрыЗаполненияДокумента();
		ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ДанныеДляПроверки);
		РеквизитыШапки = Документы[ИмяНакладной].ДанныеЗаполненияНакладной(ДанныеДляПроверки.РаспоряженияКОформлению,
			ДанныеДляПроверки);
		Документы[ИмяНакладной].ИнициализироватьПараметрыЗаполнения(ПараметрыЗаполнения, РеквизитыШапки,
			ДанныеДляПроверки.РаспоряженияКОформлению);
		
		ПараметрыОткрытия.Вставить("ИмяФормы", "Документ." + ИмяНакладной + ".ФормаОбъекта");
		ПараметрыОткрытия.Вставить("ПараметрыФормы", Новый Структура("Основание", ПараметрыЗаполнения));
		ПараметрыОткрытия.Вставить("РежимОткрытияОкнаФормы", РежимОткрытияОкнаФормы.Независимый);
		
	Иначе
		
		ПараметрыОткрытия = Документы[ИмяНакладной].ПараметрыОткрытияФормыРабочегоМеста(ХозяйственнаяОперация);
		ПараметрыОткрытия.ПараметрыФормы.Вставить("КлючНазначенияФормы", "ВводНаОсновании");
		ПараметрыОткрытия.ПараметрыФормы.Вставить("Распоряжения",        Распоряжения);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкнаФормы", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

Функция АктВыполненныхРаботПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды))
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам") Тогда
		
		Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() > 0 Тогда
			ДокументОснование = ПараметрКоманды[0];
		Иначе
			ДокументОснование = ПараметрКоманды;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ПродажиВызовСервера.СформироватьДанныеЗаполненияАктовВыполненныхРабот(ПараметрКоманды, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

Функция ПриобретениеТоваровУслугПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладПоступления",  Неопределено);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды))
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		
		Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() > 0 Тогда
			ДокументОснование = ПараметрКоманды[0];
		Иначе
			ДокументОснование = ПараметрКоманды;
		КонецЕсли;
		
		Если ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ДокументОснование,"ПриобретениеТоваровУслуг") Тогда
			
			ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ЗакупкиВызовСервера.СформироватьДанныеЗаполненияПоступления(ПараметрКоманды, "ПриобретениеТоваровУслуг", РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

Функция ПриемкаТоваровНаХранениеПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладПоступления",  Неопределено);
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив")
		И ПараметрКоманды.Количество() > 0 Тогда
		
		ДокументОснование = ПараметрКоманды[0];
		
	Иначе
		ДокументОснование = ПараметрКоманды;
	КонецЕсли;
	
	ХозяйственнаяОперация = Неопределено;
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды))
		Или ХозяйственнаяОперация = Неопределено
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		
		Если ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ДокументОснование, "ПриемкаТоваровНаХранение", ХозяйственнаяОперация) Тогда
			ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ЗакупкиВызовСервера.СформироватьДанныеЗаполненияПоступления(ПараметрКоманды, "ПриемкаТоваровНаХранение", РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

Функция ОперацияПоПлатежнойКарте_ВозвратПараметрыЗаполнения(ПараметрКоманды) Экспорт
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив")
		И ПараметрКоманды.Количество() > 0 Тогда
		ДанныеОснования = ПараметрКоманды[0];	
	Иначе
		ДанныеОснования = ПараметрКоманды;
	КонецЕсли;	
	
	Возврат Новый Структура("Основание", Новый Структура("Основание, ХозяйственнаяОперация", ДанныеОснования, Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту));
	
КонецФункции

#КонецОбласти

#Область ЗаказНаПеремещение

Функция СоздатьЗаказНаПеремещениеНаОснованииПриобретенияТоваровУслугПоГруппеСкладовПараметрыСоздания(ПараметрКоманды) Экспорт
	
	ПараметрыСозданияПоГруппеСкладов = Документы.ЗаказНаПеремещение.ПараметрыСозданияПоГруппеСкладовПоПоступлениюТоваровУслуг(ПараметрКоманды);
	Возврат ПараметрыСозданияПоГруппеСкладов;
	
КонецФункции

Функция СоздатьЗаказНаПеремещениеНаОснованииПриемкиТоваровНаХранениеПоГруппеСкладовПараметрыСоздания(ПараметрКоманды) Экспорт
	
	ПараметрыСозданияПоГруппеСкладов = Документы.ЗаказНаПеремещение.ПараметрыСозданияПоГруппеСкладовПоПриемкеТоваровНаХранение(ПараметрКоманды);
	Возврат ПараметрыСозданияПоГруппеСкладов;
	
КонецФункции

#КонецОбласти

#Область ПеремещениеТоваров

Функция СоздатьПеремещениеТоваровНаОснованииПоГруппеСкладовПараметрыСоздания(ПараметрКоманды) Экспорт
	
	ПараметрыСозданияПоГруппеСкладов = Документы.ПеремещениеТоваров.ПараметрыСозданияПоГруппеСкладов(ПараметрКоманды);
	Возврат ПараметрыСозданияПоГруппеСкладов;
	
КонецФункции

#КонецОбласти

#Область РеализацияТоваровУслуг

Функция РеализацияТоваровУслугПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладОтгрузки", 			Неопределено);
	ПараметрыОснования.Вставить("ВариантОформленияПродажи", Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПараметрКоманды))
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам") Тогда
		
		Если ТипЗнч(ПараметрКоманды) = Тип("Массив")
			И ПараметрКоманды.Количество() > 0 Тогда
			
			ДокументОснование = ПараметрКоманды[0];
			
		Иначе
			ДокументОснование = ПараметрКоманды;
		КонецЕсли;
		
		ХозяйственнаяОперация = Неопределено;
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
			ХозяйственнаяОперацияРеализация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ХозяйственнаяОперация");
			ХозяйственнаяОперация = ПродажиСервер.ПолучитьХозяйственнуюОперациюРеализацииПоВозврату(ХозяйственнаяОперацияРеализация);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ДокументОснование, "РеализацияТоваровУслуг", ХозяйственнаяОперация) Тогда
			ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		ИмяДокумента   = "РеализацияТоваровУслуг";
		
		Если НЕ ПродажиВызовСервера.СформироватьДанныеЗаполненияРеализации(ПараметрКоманды, ИмяДокумента, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",      РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование",   ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

#КонецОбласти

#Область СчетНаОплату

Функция СчетНаОплатуРеализацияАктПолучитьПараметрыОткрытияФормы(Основание) Экспорт
	
	ПараметрыОткрытияФормы = Неопределено;
	
	МассивЗаказов = СчетНаОплатуРеализацияАктПолучитьЗаказыРеализацииСервер(Основание);
	
	Если СчетНаОплатуРеализацияАктПроверитьПорядокРасчетов(Основание)
	 ИЛИ МассивЗаказов.Количество() = 0 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаДокумента");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("Основание", Основание));
		
	ИначеЕсли МассивЗаказов.Количество() = 1 Тогда
		ДокументОснование = ПродажиВызовСервера.ПолучитьОснованиеДляСчетаНаОплату(МассивЗаказов[0]);
		ПараметрыФормы = Новый Структура("ДокументОснование", ДокументОснование);
			
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", ПараметрыФормы);
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

Функция СчетНаОплатуРеализацияАктПроверитьПорядокРасчетов(Основание)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ПорядокРасчетов");
	
	Возврат ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоЗаказам;
	
КонецФункции 

Функция СчетНаОплатуРеализацияАктПолучитьЗаказыРеализацииСервер(Основание)
	
	Запрос = Новый Запрос();
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомитентуОЗакупках") Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ОтчетКомитентуОЗакупкахТовары.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	Документ.ОтчетКомитентуОЗакупках.Товары КАК ОтчетКомитентуОЗакупкахТовары
			|ГДЕ
			|	ОтчетКомитентуОЗакупкахТовары.Ссылка = &Основание
			|	И ОтчетКомитентуОЗакупкахТовары.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
			|
			|";
		Запрос.УстановитьПараметр("Основание", Основание);
		РезультатЗапроса = Запрос.Выполнить();
		МассивЗаказов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	Иначе
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РеализацияТоваровУслугТовары.ЗаказКлиента КАК ЗаказКлиента
			|ПОМЕСТИТЬ
			|	Заказы
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
			|ГДЕ
			|	РеализацияТоваровУслугТовары.Ссылка = &Основание
			|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
			|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
			|	И РеализацияТоваровУслугТовары.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	РеализацияТоваровУслуг.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|ГДЕ
			|	РеализацияТоваровУслуг.Ссылка = &Основание
			|	И РеализацияТоваровУслуг.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
			|	И РеализацияТоваровУслуг.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
			|	И РеализацияТоваровУслуг.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	АктВыполненныхРаботУслуги.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	Документ.АктВыполненныхРабот.Услуги КАК АктВыполненныхРаботУслуги
			|ГДЕ
			|	АктВыполненныхРаботУслуги.Ссылка = &Основание
			|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
			|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
			|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	АктВыполненныхРабот.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
			|ГДЕ
			|	АктВыполненныхРабот.Ссылка = &Основание
			|	И АктВыполненныхРабот.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
			|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
			|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
			|;
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Заказы.ЗаказКлиента КАК ЗаказКлиента
			|ИЗ
			|	Заказы КАК Заказы
			|
			|";
			
		Запрос.УстановитьПараметр("Основание", Основание);
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		МассивЗаказов = РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
		
	КонецЕсли;
	
	Возврат МассивЗаказов;
	
КонецФункции

Функция СчетНаОплатуПоДоговоруПроверитьВозможностьСозданияСчетовНаОплату(Договор) Экспорт
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокРасчетов");
	Возврат ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов
		Или ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамНакладным;
	
КонецФункции


#КонецОбласти

#Область ИзменениеАссортимента

Функция УстановитьПоддержаниеЗапасов(ПараметрКоманды) Экспорт
	
	Возврат Обработки.НастройкаПоддержанияЗапасов.УстановитьПоддержаниеЗапасовДляДокументаИзмененияАссортимента(ПараметрКоманды);
	
КонецФункции

#КонецОбласти

Функция ПроверитьСтатусПересчетаНаСервере(ПересчетСсылка) Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("МожноОткрытьПомощник", Ложь);
	РезультатПроверки.Вставить("СообщениеПользователю", "");
	
	Статус = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПересчетСсылка, "Статус");
	Если Статус = Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
		РезультатПроверки.МожноОткрытьПомощник = Истина;
	Иначе
		СообщениеПользователю = НСтр("ru = 'Документ ""%ПересчетТоваров%"" находится в статусе ""%ТекущийСтатус%"". Воспользоваться помощником оформления складских актов можно только в статусе ""%СтатусВыполнено%"".'");
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%ПересчетТоваров%", ПересчетСсылка);
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%ТекущийСтатус%", Статус);
		СообщениеПользователю = СтрЗаменить(СообщениеПользователю, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
		РезультатПроверки.СообщениеПользователю	= СообщениеПользователю;
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции



Функция АктОРасхожденияхПослеПриемкиПараметрыОткрытияФормы(ПараметрКоманды) Экспорт
	
	Если ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ПараметрКоманды[0], "АктОРасхожденияхПослеПриемки") Тогда
		ПараметрыОснования = Новый Структура;
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды[0]);
		
		ПараметрыФормы = Новый Структура("Основание", ПараметрыОснования);
		
		Возврат ПараметрыФормы;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#Область ПередачаТоваровХранителю

Функция ПередачаТоваровХранителюПараметрыОткрытияФормы(ОбъектыОснований) Экспорт
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладОтгрузки", Неопределено);
	ПараметрыОснования.Вставить("ТекстОшибки", "");
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОбъектыОснований))
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам") Тогда
		
		Если ТипЗнч(ОбъектыОснований) = Тип("Массив")
			И ОбъектыОснований.Количество() > 0 Тогда
			
			ДокументОснование = ОбъектыОснований[0];
			
		Иначе
			ДокументОснование = ОбъектыОснований;
		КонецЕсли;
		
		Если ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ДокументОснование, "ПередачаТоваровХранителю") Тогда
			ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
		ИначеЕсли ОбщегоНазначенияУТ.ПроверитьОперациюРаспоряжения(ДокументОснование, "ПередачаНаКомиссию")
			И ЗначениеЗаполнено(ДокументОснование.Договор) Тогда
			ПараметрыОснования.Вставить("ДокументОснование", ДокументОснование);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		ИмяДокумента   = "ПередачаТоваровХранителю";
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("МассивСсылок", ОбъектыОснований);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ЗаказКлиента.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.ЗаказКлиента КАК ЗаказКлиента
			|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорЗаказа
			|		ПО ДоговорЗаказа.Ссылка = ЗаказКлиента.Договор
			|ГДЕ
			|	ЗаказКлиента.Ссылка В(&МассивСсылок)
			|	И ((ЗаказКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию)
			|		И НЕ ЗаказКлиента.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
			|		И ДоговорЗаказа.КомиссионныеПродажи25)
			|		ИЛИ ЗаказКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи))";
		
		РезультатПроверкиОбъектыОснований = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		Если РезультатПроверкиОбъектыОснований.Количество() = 0 Тогда
			
			Если ОбъектыОснований.Количество() = 1 Тогда
				ТекстОшибки = НСтр("ru = 'Команда не может быть выполнена для данного документа'");
			Иначе
				ТекстОшибки = НСтр("ru = 'Команда не может быть выполнена для выбранных документов'");
			КонецЕсли;
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			
			Возврат Неопределено;
			
		КонецЕсли;
		
		Если Не ПродажиВызовСервера.СформироватьДанныеЗаполненияРеализации(РезультатПроверкиОбъектыОснований, ИмяДокумента, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование", РезультатПроверкиОбъектыОснований);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции

#КонецОбласти

#Область КорректировкаНазначенияТоваров

Функция СоздатьКорректировкуНазначенияТоваровНаОснованииЗаказаКлиентаПроверкаТипаНазначения(ПараметрыКоманды) Экспорт
	
	Возврат Документы.КорректировкаНазначенияТоваров.СоздатьКорректировкуНазначенияТоваровНаОснованииЗаказаКлиентаПроверкаТипаНазначения(ПараметрыКоманды);
	
КонецФункции

#КонецОбласти

#Область ОтгрузкаТоваровСХранения

Функция СоздатьОтгрузкуТоваровСХраненияНаОснованииЗаказаКлиентаПроверкаТипаНазначения(ПараметрыКоманды) Экспорт
	
	Возврат Документы.ОтгрузкаТоваровСХранения.СоздатьОтгрузкуТоваровСХраненияНаОснованииЗаказаКлиентаПроверкаХозОперации(ПараметрыКоманды);
	
КонецФункции


#КонецОбласти

#КонецОбласти
