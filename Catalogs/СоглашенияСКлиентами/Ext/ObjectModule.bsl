﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в соглашении с клиентом.
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаВзаиморасчетов = УсловияПродаж.ВалютаВзаиморасчетов;
	Валюта = УсловияПродаж.Валюта;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ХозяйственнаяОперация) Тогда
		ХозяйственнаяОперация = УсловияПродаж.ХозяйственнаяОперация;
		ПорядокРасчетов       = УсловияПродаж.ПорядокРасчетов;
		ЦенаВключаетНДС       = УсловияПродаж.ЦенаВключаетНДС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГрафикОплаты) Тогда
		ГрафикОплаты = УсловияПродаж.ГрафикОплаты;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Календарь) Тогда
		Календарь = УсловияПродаж.Календарь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ОплатаВВалюте) Тогда
		ОплатаВВалюте = УсловияПродаж.ОплатаВВалюте;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияПродаж.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.СтатьяДвиженияДенежныхСредств) Тогда
		СтатьяДвиженияДенежныхСредств = УсловияПродаж.СтатьяДвиженияДенежныхСредств;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.СрокПоставки) Тогда
		СрокПоставки = УсловияПродаж.СрокПоставки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ВидЦен) Тогда
		ВидЦен = УсловияПродаж.ВидЦен;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
		
		Организация = УсловияПродаж.Организация;
		
	КонецЕсли;
	
	СуммаДокумента = УсловияПродаж.СуммаДокумента;
	Регулярное     = УсловияПродаж.Регулярное;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Период) Тогда
		Период = УсловияПродаж.Период;
	КонецЕсли;
	
	КоличествоПериодов = УсловияПродаж.КоличествоПериодов;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Если ЗначениеЗаполнено(УсловияПродаж.ДатаНачалаДействия) Тогда
		ДатаНачалаДействия = ?(УсловияПродаж.ДатаНачалаДействия < ТекущаяДата, ТекущаяДата, УсловияПродаж.ДатаНачалаДействия);
	КонецЕсли;
	Если ЗначениеЗаполнено(УсловияПродаж.ДатаОкончанияДействия) Тогда
		ДатаОкончанияДействия = ?(УсловияПродаж.ДатаОкончанияДействия >= ТекущаяДата, УсловияПродаж.ДатаОкончанияДействия, Неопределено);;
	КонецЕсли;
		
	Если Регулярное И ЗначениеЗаполнено (Период) И
		ЗначениеЗаполнено (КоличествоПериодов) Тогда
		
		Если Не ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
			ДатаНачалаДействия = Дата;
		КонецЕсли;

		Если ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
			ДатаОкончанияДействия = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачалаДействия, Период, КоличествоПериодов);
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользуетсяВРаботеТорговыхПредставителей = УсловияПродаж.ИспользуетсяВРаботеТорговыхПредставителей;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) Тогда
		Склад = УсловияПродаж.Склад;
	КонецЕсли;
	
	СегментНоменклатуры = УсловияПродаж.СегментНоменклатуры;
	
	ОграничиватьРучныеСкидки  = УсловияПродаж.ОграничиватьРучныеСкидки;
	ПроцентРучнойСкидки  = УсловияПродаж.ПроцентРучнойСкидки;
	ПроцентРучнойНаценки = УсловияПродаж.ПроцентРучнойНаценки;
	
	Если ЗначениеЗаполнено(УсловияПродаж.СпособРасчетаВознаграждения) Тогда
		СпособРасчетаВознаграждения = УсловияПродаж.СпособРасчетаВознаграждения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ПроцентВознаграждения) Тогда
		ПроцентВознаграждения = УсловияПродаж.ПроцентВознаграждения;
	КонецЕсли;
	
	УдержатьВознаграждение                        = УсловияПродаж.УдержатьВознаграждение;
	ИспользуютсяДоговорыКонтрагентов              = УсловияПродаж.ИспользуютсяДоговорыКонтрагентов;
	ДоступноВнешнимПользователям                  = УсловияПродаж.ДоступноВнешнимПользователям;
	ВозможнаРеализацияБезПереходаПраваСобственности = УсловияПродаж.ВозможнаРеализацияБезПереходаПраваСобственности;
	
	ВозвращатьМногооборотнуюТару                  = УсловияПродаж.ВозвращатьМногооборотнуюТару;
	СрокВозвратаМногооборотнойТары                = УсловияПродаж.СрокВозвратаМногооборотнойТары;
	РассчитыватьДатуВозвратаТарыПоКалендарю       = УсловияПродаж.РассчитыватьДатуВозвратаТарыПоКалендарю;
	ТребуетсяЗалогЗаТару                          = УсловияПродаж.ТребуетсяЗалогЗаТару;
	КалендарьВозвратаТары                         = УсловияПродаж.КалендарьВозвратаТары;
	ОбеспечиватьЗаказыОбособленно                 = УсловияПродаж.ОбеспечиватьЗаказыОбособленно;
	МинимальнаяСуммаЗаказа                        = УсловияПродаж.МинимальнаяСуммаЗаказа;
	ЧастотаЗаказа                                 = УсловияПродаж.ЧастотаЗаказа;
	КомиссионерВедетУчетПоРНПТ                    = УсловияПродаж.КомиссионерВедетУчетПоРНПТ;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в коммерческом предложении.
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ОчиститьСоглашение = Истина;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
	
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура(
				"ТолькоТиповые,
				|УчитыватьГруппыСкладов, ВыбранноеСоглашение",
				Истина,
				Истина,
				Справочники.СоглашенияСКлиентами.ПустаяСсылка()));
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			ОчиститьСоглашение = Ложь;
			
			Если УсловияПродажПоУмолчанию.Соглашение <> Соглашение Тогда
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				ЗаполнитьТабличныеЧастиПоСоглашению(Соглашение);
			КонецЕсли;
			
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	КонецЕсли;
	
	Если ОчиститьСоглашение Тогда
		Соглашение = Справочники.СоглашенияСКлиентами.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в соглашении.
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение, Истина);
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	ЗаполнитьТабличныеЧастиПоСоглашению(Соглашение);
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

// Заполняет скидки и наценки по соглашению в соглашении.
//
Процедура ЗаполнитьСкидкиИНаценкиПоСоглашению() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		НаборЗаписей = РегистрыСведений.ДействиеСкидокНаценок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Источник.Установить(ЭтотОбъект.Ссылка);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать(Истина);
	
		СоглашениеСсылка = Соглашение;
		СкидкиНаценкиСервер.ПриЗаписиНаСервереИсточниковДействияСкидокНаценок(ЭтотОбъект, СоглашениеСсылка);

		ЗафиксироватьТранзакцию();
	
	Исключение
		
		ОтменитьТранзакцию();
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
		
КонецПроцедуры

// Заполняет вариант расчета цен по параметрам соглашения.
//
Процедура ЗаполнитьВариантРасчетаЦен() Экспорт
	
	ЗаполненВидЦен = ЗначениеЗаполнено(ВидЦен); 
	
	ЕстьСтрокиЦеновыеГруппы = (ЦеновыеГруппы.Количество() > 0);
	ЕстьСтрокиЦеныТовары = Ложь;
	ЕстьСтрокиВидыЦенТовары = Ложь;
	
	// Анализ ТЧ Товары.
	Если Товары.Количество()>0 Тогда
		ЕстьСтрокиТовары = Истина;
		
		Если Товары.Найти(Справочники.ВидыЦен.ПустаяСсылка(),"ВидЦены") <> Неопределено Тогда
			ЕстьСтрокиЦеныТовары = Истина;
		КонецЕсли;
		
		Если Товары.Найти(0,"Цена") <> Неопределено Тогда
			ЕстьСтрокиВидыЦенТовары = Истина;
		КонецЕсли;
	Иначе
		ЕстьСтрокиТовары = Ложь;
	КонецЕсли;
	
	Если ЗаполненВидЦен Тогда
		Если ЕстьСтрокиЦеновыеГруппы Тогда
			Если ЕстьСтрокиТовары Тогда
				Если ЕстьСтрокиЦеныТовары И ЕстьСтрокиВидыЦенТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоЦеновымГруппамВидыЦенПоНоменклатуреУточненныеЦеныПоНоменклатуре;
				ИначеЕсли ЕстьСтрокиЦеныТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоЦеновымГруппамУточненныеЦеныПоНоменклатуре;
				Иначе
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоЦеновымГруппамВидыЦенПоНоменклатуре;
				КонецЕсли;
			Иначе
				ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоЦеновымГруппам;
			КонецЕсли;
		Иначе
			Если ЕстьСтрокиТовары Тогда
				Если ЕстьСтрокиЦеныТовары И ЕстьСтрокиВидыЦенТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоНоменклатуреУточненныеЦеныПоНоменклатуре;
				ИначеЕсли  ЕстьСтрокиЦеныТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеУточненныеЦеныПоНоменклатуре;
				Иначе
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапкеВидыЦенПоНоменклатуре;
				КонецЕсли;
			Иначе
				ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидЦенВШапке;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЕстьСтрокиЦеновыеГруппы Тогда
			Если ЕстьСтрокиТовары Тогда
				Если ЕстьСтрокиЦеныТовары И ЕстьСтрокиВидыЦенТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоЦеновымГруппамВидыЦенПоНоменклатуреУточненныеЦеныПоНоменклатуре;
				ИначеЕсли ЕстьСтрокиЦеныТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоЦеновымГруппамУточненныеЦеныПоНоменклатуре;
				Иначе
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоЦеновымГруппамВидыЦенПоНоменклатуре;
				КонецЕсли;
			Иначе
				ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоЦеновымГруппам;
			КонецЕсли;
		Иначе
			Если ЕстьСтрокиТовары Тогда
				Если ЕстьСтрокиЦеныТовары И ЕстьСтрокиВидыЦенТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоНоменклатуреУточненныеЦеныПоНоменклатуре;
				ИначеЕсли ЕстьСтрокиЦеныТовары Тогда
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.УточненныеЦеныПоНоменклатуре;
				Иначе
					ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.ВидыЦенПоНоменклатуре;
				КонецЕсли;
			Иначе
				ВариантРасчетаЦен = Перечисления.ВариантыРасчетаЦенПоСоглашениямСКлиентами.БезЦен;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Контрагенты") Тогда
		ЗаполнитьДокументНаОснованииКонтрагента(ДанныеЗаполнения);
	КонецЕсли;

	ИнициализироватьСправочник();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Справочники.СоглашенияСКлиентами.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если Типовое Тогда
		
		// В типовом соглашении не нужно заполнять реквизиты "Партнер", "Соглашение"
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Соглашение");
		
	КонецЕсли;
	
	// В индивидуальных соглашениях при условии использования только их
	// и при условии совместного использования с типовыми, но при праве отклонения от условий продаж
	// соглашение заполнять не нужно.
	ИспользоватьТиповыеСоглашенияСКлиентами        = ПолучитьФункциональнуюОпцию("ИспользоватьТиповыеСоглашенияСКлиентами");
	ИспользоватьИндивидуальныеСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьИндивидуальныеСоглашенияСКлиентами");
	
	ТолькоИндивидуальные = НЕ ИспользоватьТиповыеСоглашенияСКлиентами И ИспользоватьИндивидуальныеСоглашенияСКлиентами;
	ОтклонениеОтУсловийПродаж = ПраваПользователяПовтИсп.ОтклонениеОтУсловийПродаж();
	
	Если Не Типовое 
		И (ТолькоИндивидуальные 
		Или Не ИспользоватьИндивидуальныеСоглашенияСКлиентами
		Или (ИспользоватьТиповыеСоглашенияСКлиентами И ИспользоватьИндивидуальныеСоглашенияСКлиентами И ОтклонениеОтУсловийПродаж))Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Соглашение");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару");
	ИспользоватьГрафикиОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиОплаты");
	КоличествоЭтапов = ЭтапыГрафикаОплаты.Количество();
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаВзаиморасчетов");
		
	КонецЕсли;
	
	Если НЕ ДоступноВнешнимПользователям Тогда
		
		// В соглашении не для внешних пользователей не обязательно заполнять "ВидЦен", "График оплаты", "Этапы оплаты", "Организация".
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
		МассивНепроверяемыхРеквизитов.Добавить("ВидЦен");
		МассивНепроверяемыхРеквизитов.Добавить("ВидПлана");
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты");
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты");
		
		Если Не ИспользоватьГрафикиОплаты
			И КоличествоЭтапов = 0 Тогда
			
			ТекстОшибки = НСтр("ru='Необходимо заполнить этапы графика оплаты'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "НадписьОплата", ,Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ИспользоватьГрафикиОплаты
		Или КоличествоЭтапов > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикОплаты");
		
		Если ТребуетсяЗалогЗаТару Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентПлатежа");
			Для Каждого ЭтапОплаты Из ЭтапыГрафикаОплаты Цикл
				Если Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентПлатежа) И Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентЗалогаЗаТару) Тогда
					ТекстОшибки = НСтр("ru='Для этапа должен быть указан процент платежа или процент залога за тару в строке %НомерСтроки% списка ""Этапы графика оплаты""'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ЭтапОплаты.НомерСтроки);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
												ТекстОшибки,
												ЭтотОбъект,
												ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", ЭтапОплаты.НомерСтроки, "ПроцентПлатежа"),
												,
												Отказ);
				КонецЕсли;
			КонецЦикла;
			
			Если ЭтапыГрафикаОплаты.Итог("ПроцентЗалогаЗаТару") <> 100 И ЭтапыГрафикаОплаты.Количество() > 0 Тогда	
				ТекстОшибки = НСтр("ru='Процент залога за тару по всем этапам оплаты должен быть равен 100%'");
				АдресОшибки = "НадписьОплата";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , АдресОшибки, , Отказ);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// Дата начала действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала действия соглашения должна быть не меньше даты соглашения'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты соглашения'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия соглашения должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// При передаче на комиссию или на хранение можно указать только график с кредитными этапами оплаты.
	Если (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
			Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи)
		И ЗначениеЗаполнено(ГрафикОплаты)
		И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГрафикОплаты, "ТолькоКредитныеЭтапы") Тогда
		
		ТекстОшибки = НСтр("ru='Необходимо указать график оплаты, содержащий только кредитные этапы'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ГрафикОплаты",
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаДействия");
	МассивНепроверяемыхРеквизитов.Добавить("СуммаДокумента");
	МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодов");
	МассивНепроверяемыхРеквизитов.Добавить("Период");
	
	Если Регулярное Тогда
		
		// В регулярном соглашении должна быть указана сумма, периодичность, количество периодов, дата начала действия.
		
		Если Не ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
			
			ТекстОшибки = НСтр("ru='В регулярном соглашении необходимо заполнить поле ""Дата начала действия""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуммаДокумента) Тогда
			
			ТекстОшибки = НСтр("ru='В регулярном соглашении необходимо заполнить поле ""Сумма""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"СуммаДокумента",
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КоличествоПериодов) Тогда
			
			ТекстОшибки = НСтр("ru='В регулярном соглашении необходимо заполнить поле ""Количество периодов""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"КоличествоПериодов",
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Период) Тогда
			
			ТекстОшибки = НСтр("ru='В регулярном соглашении необходимо заполнить поле ""Период""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Период",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если РассчитыватьДатуВозвратаТарыПоКалендарю И ВозвращатьМногооборотнуюТару И Не ЗначениеЗаполнено(КалендарьВозвратаТары) Тогда
		
		ТекстОшибки = НСтр("ru='Не указан календарь для учета возврата тары по рабочим дням.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.КалендарьВозвратаТары",
			,
			Отказ);
		
	КонецЕсли;
	
	// Дата окончания действия соглашения должна быть не меньше, чем дата окончания указанного количества периодов.
	Если Регулярное И ЗначениеЗаполнено(Период) И ЗначениеЗаполнено(КоличествоПериодов) И
		ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		
		ДатаНачалаБлижайшегоПериода =  ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуНачалаБлижайшегоПериода(ДатаНачалаДействия, Период);
		ДатаОкончанияПериода = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачалаБлижайшегоПериода, Период, КоличествоПериодов);
		
		Если ДатаОкончанияПериода > КонецДня(ДатаОкончанияДействия) Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения не должна быть меньше, чем дата окончания указанного количества периодов ""%ДатаОкончанияПериода%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаОкончанияПериода%", Формат(ДатаОкончанияПериода,"ДЛФ=DD"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// В табличной части Товары должен быть заполнен вид цен или фиксированная цена
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ВидЦены");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Цена");
	
	Для ТекИндекс = 0 По Товары.Количество()-1 Цикл
		
		ТекущаяСтрокаТовары = Товары[ТекИндекс]; // СтрокаТабличнойЧасти
		
		АдресОшибки = " " + НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", ТекущаяСтрокаТовары.НомерСтроки);
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрокаТовары.ВидЦены) И
			Не ЗначениеЗаполнено(ТекущаяСтрокаТовары.Цена) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Вид цены"" или колонка ""Цена""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрокаТовары.НомерСтроки, "ВидЦены"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоСоглашениям")
		И (ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
			Или ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.ВидЦен");
		
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокРасчетов");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СценарийПланирования) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидПлана");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	СкладГруппа = Справочники.Склады.ЭтоГруппаИСкладыИспользуютсяВТЧДокументовПродажи(Склад);
	
	Если СкладГруппа И (ИспользуетсяВРаботеТорговыхПредставителей) Тогда
		
		ТекстОшибки = НСтр("ru='Запрещено выбирать группу складов, если соглашение используется в работе торговых представителей'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Склад",
			,
			Отказ);
		
	КонецЕсли;
	
	Если НЕ Типовое И ТолькоИндивидуальные И НЕ ОтклонениеОтУсловийПродаж И 
		НЕ Согласован И Статус <> Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано Тогда
		
		ТекстОшибки = НСтр("ru='Запрещено изменять статус несогласованного соглашения, если нет прав на отклонение от условий продаж. Необходимо согласование.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Статус",
			,
			Отказ);
		
	КонецЕсли;
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоставкаПодПринципала Тогда
		Если Не ИспользуютсяДоговорыКонтрагентов Тогда
			
			ТекстОшибки = НСтр("ru='При использовании ""Поставки под принципала"" необходимо использовать договор с контрагентами.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				"Объект.ИспользуютсяДоговорыКонтрагентов",
				,
				Отказ);
		КонецЕсли;
		Если Не ОбеспечиватьЗаказыОбособленно Тогда
			ТекстОшибки = НСтр("ru='При использовании ""Поставки под принципала"" необходимо использовать обособленное обеспечение.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ОбеспечиватьЗаказыОбособленно",
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано);
	
	Если Типовое Тогда
		Соглашение = Справочники.СоглашенияСКлиентами.ПустаяСсылка();
		Партнер    = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	Иначе
		СегментПартнеров = Справочники.СегментыПартнеров.ПустаяСсылка();
	КонецЕсли;
	
	НастройкиПродажДляПользователейСервер.ОчиститьНеиспользуемыеПравилаПродаж(ЭтотОбъект);
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
	КонецЕсли;
	
	ЗаполнитьВариантРасчетаЦен();
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоставкаПодПринципала Тогда
		ВозвращатьМногооборотнуюТару = Ложь;
		ТребуетсяЗалогЗаТару         = Ложь;
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
			  И КомиссионныеПродажи25 Тогда
		ВозвращатьМногооборотнуюТару   = Ложь;
		СрокВозвратаМногооборотнойТары = 0;
		ТребуетсяЗалогЗаТару           = Ложь;
	КонецЕсли;	
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Справочники.СоглашенияСКлиентами.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Если СценарийПланирования.Пустая()
		И НЕ ВидПлана.Пустая() Тогда
		ВидПлана = Справочники.ВидыПланов.ПустаяСсылка();
	КонецЕсли;
	
	ЗаполнитьСлужебныеРеквизитыДляОграниченияДоступа();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус                  = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано;
	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';
	ИндивидуальныйВидЦены   = Справочники.ВидыЦен.ПустаяСсылка();
	
	ИнициализироватьСправочник(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	Если ЗначениеЗаполнено(Партнер) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Партнер;
	КонецЕсли;

	Если ЗначениеЗаполнено(Организация) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Организация;
	КонецЕсли;

	Если ЗначениеЗаполнено(Склад) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Склад;
	КонецЕсли;

	Если Таблица.Количество() = 0 Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьТабличныеЧастиПоСоглашению(Знач СоглашениеСКлиентом)
	
	Если СоглашениеСКлиентом <> ПредопределенноеЗначение("Справочник.СоглашенияСКлиентами.ПустаяСсылка") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СоглашенияСКлиентами.Товары.(
		|		Ссылка,
		|		НомерСтроки,
		|		Номенклатура,
		|		Характеристика,
		|		Упаковка,
		|		ВидЦены,
		|		Цена,
		|		СрокПоставки
		|	) КАК Товары,
		|	СоглашенияСКлиентами.ЦеновыеГруппы.(
		|		Ссылка,
		|		НомерСтроки,
		|		ЦеноваяГруппа,
		|		ВидЦен,
		|		СрокПоставки,
		|		ПроцентРучнойСкидки,
		|		ПроцентРучнойНаценки
		|	) КАК ЦеновыеГруппы,
		|	СоглашенияСКлиентами.ЭтапыГрафикаОплаты.(
		|		Ссылка,
		|		НомерСтроки,
		|		ВариантОплаты,
		|		ВариантОтсчета,
		|		Сдвиг,
		|		ПроцентПлатежа
		|	) КАК ЭтапыГрафикаОплаты
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &СоглашениеСКлиентом");
		
		Запрос.УстановитьПараметр("СоглашениеСКлиентом", СоглашениеСКлиентом);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Товары.Загрузить(Выборка.Товары.Выгрузить());
		ЦеновыеГруппы.Загрузить(Выборка.ЦеновыеГруппы.Выгрузить());
		ЭтапыГрафикаОплаты.Загрузить(Выборка.ЭтапыГрафикаОплаты.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПартнера(Знач Основание)
	
	Партнер = Основание;
	ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
	ЗаполнитьУсловияПродажПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииКонтрагента(Знач Основание)
	
	Партнер = Основание.Партнер;
	ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
	ЗаполнитьУсловияПродажПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
		ЗаполнитьУсловияПродажПоУмолчанию();
		
	ИначеЕсли ДанныеЗаполнения.Свойство("ПартнерОтбор") Тогда
		
		Партнер = ДанныеЗаполнения.ПартнерОтбор;
		ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
		ЗаполнитьУсловияПродажПоУмолчанию();
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ДанныеЗаполнения.Организация;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
		ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи Тогда
			ИспользуютсяДоговорыКонтрагентов = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьСправочник(ЗаполнятьВсеРеквизиты = Истина)

	Менеджер = Пользователи.ТекущийПользователь();
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеСоглашенийСКлиентами")
	 Или ПраваПользователяПовтИсп.ОтклонениеОтУсловийПродаж() Тогда
		Статус = Перечисления.СтатусыСоглашенийСКлиентами.Действует;
	Иначе
		Статус = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	КонецЕсли;
	
	Если ЗаполнятьВсеРеквизиты Тогда
		
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		ВалютаВзаиморасчетов = Валюта;
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи"));
		ОплатаВВалюте = ВзаиморасчетыСервер.ПолучитьОплатуВВалютеПоУмолчанию();
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(Организация, ВалютаВзаиморасчетов, ХозяйственнаяОперация);
	
		Реквизиты = Новый Структура("ИспользуютсяДоговорыКонтрагентов,ПорядокРасчетов");
		ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, Реквизиты);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСлужебныеРеквизитыДляОграниченияДоступа() Экспорт
	
	Если Типовое Тогда
		ВидСоглашенияДляОграниченияЧтения    = Перечисления.ВидыСоглашенийСКлиентамиДляОграниченияЧтения.Типовые;
		ВидСоглашенияДляОграниченияИзменения = Перечисления.ВидыСоглашенийСКлиентамиДляОграниченияИзменения.Типовые;
	Иначе
		ВидСоглашенияДляОграниченияЧтения    = Перечисления.ВидыСоглашенийСКлиентамиДляОграниченияЧтения.Индивидуальные;
		ВидСоглашенияДляОграниченияИзменения = Перечисления.ВидыСоглашенийСКлиентамиДляОграниченияИзменения.Индивидуальные;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
