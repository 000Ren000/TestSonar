﻿////////////////////////////////////////////////////////////////////////////////
// Варианты отчетов - Форма отчета (переопределяемый)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений:
//       * ПодчиненныйРеквизит - Строка - имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОтчета
//        - Неопределено - форма отчета.
//  СвойстваНастройки - Структура - описание настройки отчета, которая будет выведена в форме отчета, где:
//      * ПолеКД - ПолеКомпоновкиДанных - выводимая настройка.
//      * ОписаниеТипов - ОписаниеТипов - тип выводимой настройки.
//      * ЗначенияДляВыбора - СписокЗначений - указать объекты, которые будут предложены пользователю в списке выбора.
//                            Дополняет список объектов, уже выбранных пользователем ранее.
//                            При этом не следует присваивать в этот параметр новый список значений.
//      * ЗапросЗначенийВыбора - Запрос - указать запрос для выборки объектов, которыми необходимо дополнить 
//                               ЗначенияДляВыбора. Первой колонкой (с индексом 0) должен выбираться объект,
//                               который следует добавить в ЗначенияДляВыбора.Значение.
//                               Для отключения автозаполнения в свойство ЗапросЗначенийВыбора.Текст следует записать
//                               пустую строку.
//      * ОграничиватьВыборУказаннымиЗначениями - Булево - указать Истина, чтобы ограничить выбор пользователя
//                                                значениями, указанными в ЗначенияДляВыбора (его конечным состоянием).
//      * Тип - Строка.
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	// Автозаполнение параметров и отборов для всех отчетов
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Валюты")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора = ЗапросДляОтбораВалюта();
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
	Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Организации")) 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1 Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка 
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	&УправленческаяОрганизация";
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию") Тогда 
			УправленческаяОрганизация = "ИСТИНА";
		Иначе
			УправленческаяОрганизация = "НЕ Организации.Ссылка = ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)";
		КонецЕсли;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УправленческаяОрганизация", УправленческаяОрганизация);
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = ТекстЗапроса;
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Ложь;
	КонецЕсли;
	Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("ПеречислениеСсылка.ХозяйственныеОперации")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "";
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Ложь;
	КонецЕсли;
	Если Константы.БазоваяВерсия.Получить()
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.НастройкиХозяйственныхОпераций")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "
		|ВЫБРАТЬ
		|	НастройкиХозяйственныхОпераций.Ссылка
		|ИЗ
		|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
		|ГДЕ
		|	НастройкиХозяйственныхОпераций.Ссылка В(
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ЗакупкаУПоставщика),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ЗакупкаЧерезПодотчетноеЛицо),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПриемНаКомиссию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровПоставщику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровКомитенту),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.РеализацияКлиенту),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПередачаНаКомиссию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратОтКомиссионера),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровОтКлиента),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратОтРозничногоПокупателя),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеремещениеТоваровМеждуФилиалами),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеремещениеТоваров),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СписаниеТоваровПоТребованию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СторноСписанияНаРасходы),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВыдачаДенежныхСредствВКассуККМ),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВыдачаДенежныхСредствПодотчетнику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ИнкассацияДенежныхСредствВБанк),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ИнкассацияДенежныхСредствИзБанка),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.КонвертацияВалюты),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ОплатаПоставщику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеречислениеДенежныхСредствНаДругойСчет),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеречислениеВБюджет),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзБанка),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзДругойКассы),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзДругойОрганизации),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзКассыККМ),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеОплатыОтКлиента),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПрочееПоступлениеДенежныхСредств),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СдачаДенежныхСредствВБанк)
		|)";
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   Отказ - Булево - признак отказа от создания формы.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФорм.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета или настроек отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	УстановитьМакетОформленияВРежимеТакси(Форма, НовыеНастройкиКД);
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(Форма, НовыеНастройкиКД);
	
	// Преобразование расширенных отборов "через точку"
	ПреобразоватьРасширенныеОтборы(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Добавляет регистры для вывода в отчет о движениях по полю, отличному от Регистратор.
// 
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    СоответствиеРегистров - Соответствие - соответствие с данными:
//        * Ключ     - ОбъектМетаданных - регистр как объект метаданных.
//        * Значение - Строка           - имя поля регистратора.
//
Процедура ДополнитьСоответствияРегистраторовОтчетаОДвижениях(Документ, СоответствиеРегистров) Экспорт
	
	ВзаиморасчетыСервер.ДополнитьСоответствияРегистраторовОтчетаОДвижениях(Документ, СоответствиеРегистров);
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(Форма, НовыеНастройкиКД)
	ИмяОтчета = ВариантыОтчетовУТПереопределяемый.ИмяОтчетаПоКлючуОбъекта(Форма);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Организация");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "СтруктураПредприятия.Организация");
		
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ПоказыватьПродажи");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Касса");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "БанковскийСчет");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Склад");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "СтруктураПредприятия.Склад");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Подразделение");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Подразделение");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов")
		И НЕ ИмяОтчета = "ВедомостьРасчетовСКлиентами" 
		И НЕ ИмяОтчета = "ВедомостьРасчетовСПоставщиками" Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Контрагент");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Контрагент");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Характеристика");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "АналитикаНоменклатуры.Характеристика");
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Характеристика");
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаНоменклатуры.Характеристика");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Серия");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "АналитикаНоменклатуры.Серия");
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Серия");
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаНоменклатуры.Серия");
	КонецЕсли;
	
	// Валютные настройки отключаются только для отчетов без показателя "Себестоимость"
	
	Если (ИмяОтчета = "ДебиторскаяЗадолженность"
		ИЛИ ИмяОтчета = "ДебиторскаяЗадолженностьДоляПросрочки"
		ИЛИ ИмяОтчета = "КартаПродаж"
		ИЛИ ИмяОтчета = "КредиторскаяЗадолженность"
		ИЛИ ИмяОтчета = "ПлатежнаяДисциплинаКлиентов"
		ИЛИ ИмяОтчета = "АнализДоходовРасходов"
		ИЛИ ИмяОтчета = "УправленческийБаланс"
		ИЛИ ИмяОтчета = "ВедомостьРасчетовПоФинансовымИнструментам")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		ИЛИ ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Валюта");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Валюта");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВалютаОтчета");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеОтчета");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеПоДенежнымСредствам");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеПоРасчетам");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВыводитьСуммы");
	КонецЕсли;
	
	Если ИмяОтчета = "АнализДоходовРасходов"
		И НЕ Справочники.НаправленияДеятельности.ИспользуетсяУчетПоНаправлениям() Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "НаправлениеДеятельности");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВидЦены");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ОценкаЗапасовПоВидуЦен");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ЕдиницыКоличества");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами")
		И (ИмяОтчета = "ДебиторскаяЗадолженность"
		Или ИмяОтчета = "РасчетыСКлиентами"
		Или ИмяОтчета = "СостояниеРасчетовСКлиентами"
		Или ИмяОтчета = "ВедомостьРасчетовСКлиентами"
		Или ИмяОтчета = "ЗадолженностьКлиентов"
		Или ИмяОтчета = "ЗадолженностьКлиентовПоСрокам"
		Или ИмяОтчета = "ОплатыКлиентовПоСрокам") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками")
		И (ИмяОтчета = "КредиторскаяЗадолженность"
		Или ИмяОтчета = "РасчетыСПоставщиками"
		Или ИмяОтчета = "СостояниеРасчетовСПоставщиками"
		Или ИмяОтчета = "ВедомостьРасчетовСПоставщиками"
		Или ИмяОтчета = "ЗадолженностьПоставщикам"
		Или ИмяОтчета = "ЗадолженностьПоставщикамПоСрокам"
		Или ИмяОтчета = "ОплатыПоставщикамПоСрокам") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками")
		И (ИмяОтчета = "РасчетыСПартнерами" 
		Или ИмяОтчета = "ВедомостьРасчетовСПартнерами") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("КонтролироватьВыдачуПодОтчетВРазрезеЦелей")
		И (ИмяОтчета = "КонтрольВыданныхПодотчетномуЛицуАвансовПоЗаявке"
			Или ИмяОтчета = "КонтрольОперацийСДенежнымиСредствами") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "ЦельВыдачи");
	КонецЕсли;
	
	Если ИмяОтчета = "СправкаРасчетПереоценкиВалютныхСредств"
		И (ПолучитьФункциональнуюОпцию("УправлениеТорговлей") 
			ИЛИ НЕ ПолучитьФункциональнуюОпцию("ЛокализацияРФ")) Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "СчетУчета");
		
		Если НовыеНастройкиКД.Структура[0].Структура.Количество() > 0 Тогда
		
			ГруппировкаОтчета = НовыеНастройкиКД.Структура[0].Структура[0];
			
			КолонкиТаблицы = ГруппировкаОтчета.Колонки[0];
			КомпоновкаДанныхСервер.УдалитьГруппуВыбранногоПоляИзВсехНастроекОтчета(КолонкиТаблицы, "СуммаНУ");
			КомпоновкаДанныхСервер.УдалитьГруппуВыбранногоПоляИзВсехНастроекОтчета(КолонкиТаблицы, "СуммаНУДО");
			КомпоновкаДанныхСервер.УдалитьГруппуВыбранногоПоляИзВсехНастроекОтчета(КолонкиТаблицы, "ДоходНУ");
			КомпоновкаДанныхСервер.УдалитьГруппуВыбранногоПоляИзВсехНастроекОтчета(КолонкиТаблицы, "РасходНУ");
			КомпоновкаДанныхСервер.УдалитьГруппуВыбранногоПоляИзВсехНастроекОтчета(КолонкиТаблицы, "ТребуетсяНачислениеНУ");
			КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "СчетУчета");
			
			ГруппировкаРаздел = ГруппировкаОтчета.Строки[0];
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаРаздел, "СуммаНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаРаздел, "ДоходНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаРаздел, "РасходНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаРаздел, "ТребуетсяНачислениеНУ");
			
			ГруппировкаАналитика = ГруппировкаОтчета.Строки[0].Структура[0];
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаАналитика, "СуммаНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаАналитика, "ДоходНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаАналитика, "РасходНУ");
			КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(ГруппировкаАналитика, "ТребуетсяНачислениеНУ");
		
			// включим скрытые поля взамен удаленных групп
			СуммаРеглДО = Новый ПолеКомпоновкиДанных("СуммаРеглДО");
			СуммаПоКурсуРегл = Новый ПолеКомпоновкиДанных("СуммаПоКурсуРегл");
			ДоходРегл = Новый ПолеКомпоновкиДанных("ДоходРегл");
			РасходРегл = Новый ПолеКомпоновкиДанных("РасходРегл");
			ТребуетсяНачислениеРегл = Новый ПолеКомпоновкиДанных("ТребуетсяНачислениеРегл");
			
			МассивПолей = Новый Массив;
			КомпоновкаДанныхСервер.НайтиВыбранноеПолеРекурсивно(КолонкиТаблицы.Выбор.Элементы, МассивПолей, СуммаРеглДО);
			КомпоновкаДанныхСервер.НайтиВыбранноеПолеРекурсивно(КолонкиТаблицы.Выбор.Элементы, МассивПолей, СуммаПоКурсуРегл);
			КомпоновкаДанныхСервер.НайтиВыбранноеПолеРекурсивно(КолонкиТаблицы.Выбор.Элементы, МассивПолей, ДоходРегл);
			КомпоновкаДанныхСервер.НайтиВыбранноеПолеРекурсивно(КолонкиТаблицы.Выбор.Элементы, МассивПолей, РасходРегл);
			КомпоновкаДанныхСервер.НайтиВыбранноеПолеРекурсивно(КолонкиТаблицы.Выбор.Элементы, МассивПолей, ТребуетсяНачислениеРегл);
			
			Для Каждого Элемент Из МассивПолей Цикл
				Элемент.Использование = Истина;
			КонецЦикла;
			
			// удалим флаг Выводить суммы НУ
			ЭлементыОтбора = НовыеНастройкиКД.Структура[0].Отбор.Элементы;
			Если ЭлементыОтбора.Количество() = 3 Тогда
				ЭлементыОтбора.Удалить(ЭлементыОтбора[2]);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПреобразоватьРасширенныеОтборы(ЭтаФорма, КомпоновщикНастроек)
	Для Каждого Отбор Из ЭтаФорма.ФормаПараметры.Отбор Цикл
		Если ТипЗнч(Отбор.Значение) = Тип("Массив") Тогда
			СписокЗначенийОтбора = Новый СписокЗначений;
			СписокЗначенийОтбора.ЗагрузитьЗначения(Отбор.Значение);
		КонецЕсли;
		Если СтрНайти(Отбор.Ключ, "_") Тогда
			Если ТипЗнч(Отбор.Значение) = Тип("Структура")
				И Отбор.Значение.Свойство("ВидСравнения")
				И Отбор.Значение.Свойство("ПравоеЗначение") Тогда
				ЗначениеОтбора = Отбор.Значение.ПравоеЗначение;
				ВидСравненияОтбора = Отбор.Значение.ВидСравнения;
			Иначе
				Если ТипЗнч(Отбор.Значение) = Тип("Массив") Тогда
					ЗначениеОтбора = СписокЗначенийОтбора;
				Иначе
					ЗначениеОтбора = Отбор.Значение;
				КонецЕсли;
				Если ТипЗнч(Отбор.Значение) = Тип("СписокЗначений")
					ИЛИ ТипЗнч(Отбор.Значение) = Тип("Массив") Тогда
					ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
				КомпоновщикНастроек, 
				СтрЗаменить(Отбор.Ключ, "_","."),
				ЗначениеОтбора,
				ВидСравненияОтбора,,
				Новый Структура("ВПользовательскиеНастройки", Истина));
			ЭтаФорма.ФормаПараметры.Отбор.Удалить(Отбор.Ключ);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ЗапросДляОтбораВалюта()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.Код";
	
	Возврат Запрос;
КонецФункции

// Устанавливает макет оформления
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - 
// 	НовыеНастройкиКД - НастройкиКомпоновкиДанных - 
Процедура УстановитьМакетОформленияВРежимеТакси(Форма, НовыеНастройкиКД)
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ЭтоМобильныйКлиент")
		И Форма.ЭтоМобильныйКлиент Тогда
		ПараметрМакетОформленияЗначение = "ОформлениеОтчетовБежевыйМобильныйКлиент";
	Иначе
		ПараметрМакетОформленияЗначение = "ОформлениеОтчетовБежевый";
	КонецЕсли;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		ПараметрМакетОформления = НовыеНастройкиКД.ПараметрыВывода.Элементы.Найти("МакетОформления");
		Если ПараметрМакетОформления.Значение = "Main" 
			Или ПараметрМакетОформления.Значение = "Основной" Тогда
			ПараметрМакетОформления.Значение = ПараметрМакетОформленияЗначение;
			ПараметрМакетОформления.Использование = Истина;
		КонецЕсли;
		
		Для Каждого ЭлементСтруктуры Из НовыеНастройкиКД.Структура Цикл
			Если ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
				ПараметрМакетОформления = ЭлементСтруктуры.Настройки.ПараметрыВывода.Элементы.Найти("МакетОформления");
				Если ПараметрМакетОформления.Значение = "Main" 
					Или ПараметрМакетОформления.Значение = "Основной" Тогда
					ПараметрМакетОформления.Значение = ПараметрМакетОформленияЗначение;
					ПараметрМакетОформления.Использование = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		// Форма может быть не формой отчета, а формой настроек отчета.
		Если Форма.Элементы.Найти("ОтчетТабличныйДокумент") <> Неопределено Тогда
			Форма.Элементы.ОтчетТабличныйДокумент.РежимМасштабированияПросмотра = РежимМасштабированияПросмотра.Обычный;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти