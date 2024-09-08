﻿
#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ЗавершитьОбработкуШтрихкода.
// Выполняет завершение обработки штрихкода. На основании ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода
//  выполняет необходимые действия.
//
// Параметры:
//  ПараметрыЗавершенияВводаШтрихкода - (См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыЗавершенияОбработкиШтрихкода).
//  ВыполнятьОбработчикОповещения - Булево
// Возвращаемое значение:
//  Булево - возвращает Истину, если требуется дополнительная обработка пользователем, и Ложь, если все корректно
Функция ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода, ВыполнятьОбработчикОповещения = Истина) Экспорт
	
	Форма                       = ПараметрыЗавершенияВводаШтрихкода.Форма;
	РезультатОбработкиШтрихкода = ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода;
	ПараметрыСканирования       = ПараметрыЗавершенияВводаШтрихкода.ПараметрыСканирования;
	ДанныеШтрихкода             = ПараметрыЗавершенияВводаШтрихкода.ДанныеШтрихкода;
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	
	Если ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки) Тогда
		
		ДанныеШтрихкода = РезультатОбработкиШтрихкода.ДанныеШтрихкода;
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АлкогольнаяПродукция = ДанныеШтрихкода.АлкогольнаяПродукция;
		ПараметрыОткрытияФормы.Штрихкод             = ДанныеШтрихкода.Штрихкод;
		ПараметрыОткрытияФормы.ТекстОшибки          = РезультатОбработкиШтрихкода.ТекстОшибки;
		ПараметрыОткрытияФормы.ТипШтрихкода         = ДанныеШтрихкода.ТипШтрихкода;
		ПараметрыОткрытияФормы.ВидУпаковки          = ДанныеШтрихкода.ВидУпаковки;
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		Возврат Истина;
		
	КонецЕсли;
		
	Если РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда
		
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АдресДереваУпаковок = РезультатОбработкиШтрихкода.АдресДереваУпаковок;
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			РезультатОбработкиШтрихкода.ПараметрыВыбораНоменклатуры,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяВыборСправки2 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", РезультатОбработкиШтрихкода.Справки2);
		
		ПараметрыВыбораСправки2 = Новый Структура;
		ПараметрыВыбораСправки2.Вставить("РежимВыбора",        Истина);
		ПараметрыВыбораСправки2.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыВыбораСправки2.Вставить("Отбор",              Отбор);
		
		ОткрытьФорму(
			"Справочник.Справки2ЕГАИС.ФормаВыбора",
			ПараметрыВыбораСправки2,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборСправки2Завершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат Истина;
		
	КонецЕсли;
	
	Если ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции Тогда
		ШтрихкодированиеЕГАИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоАлкогольнойПродукции(Форма, ДанныеШтрихкода);
	КонецЕсли;
	
	Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
		И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет завершение обработки штрихкода. На основании ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода
//  выполняет необходимые действия.
//
// Параметры:
//  ПараметрыЗавершенияВводаШтрихкода - (См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыЗавершенияОбработкиШтрихкода).
// Возвращаемое значение:
//  Булево - возвращает Истину, если требуется дополнительная обработка пользователем, и Ложь, если все корректно
Функция ЗавершитьОбработкуШтрихкода(ПараметрыЗавершенияВводаШтрихкода) Экспорт
	
	Форма                       = ПараметрыЗавершенияВводаШтрихкода.Форма;
	ПараметрыСканирования       = ПараметрыЗавершенияВводаШтрихкода.ПараметрыСканирования;
	РезультатОбработкиШтрихкода = ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода;
	ДанныеШтрихкода             = ПараметрыЗавершенияВводаШтрихкода.ДанныеШтрихкода;
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	
	Если ПараметрыСканирования.ВыводитьСообщенияОбОшибках
		И ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки) Тогда
		
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		Если РезультатОбработкиШтрихкода.ДанныеШтрихкода <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормы, РезультатОбработкиШтрихкода.ДанныеШтрихкода);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ПараметрыОткрытияФормы.Штрихкод) Тогда
			
			Если ДанныеШтрихкода.Свойство("ФорматBase64") Тогда
				Штрихкод = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.Base64ВШтрихкод(ДанныеШтрихкода.Штрихкод);
			Иначе
				Штрихкод = ДанныеШтрихкода.Штрихкод;
			КонецЕсли;
			
			ПараметрыОткрытияФормы.Штрихкод = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Штрихкод, "");
			
		КонецЕсли;
		ПараметрыОткрытияФормы.ТекстОшибки = РезультатОбработкиШтрихкода.ТекстОшибки;
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если ПараметрыСканирования.ВыводитьСообщенияОбОшибках
		И РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда
		
		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АдресДереваУпаковок = РезультатОбработкиШтрихкода.АдресДереваУпаковок;
		
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры Тогда
		
		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
			РезультатОбработкиШтрихкода.ПараметрыВыбораНоменклатуры,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяВыборСправки2 Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", РезультатОбработкиШтрихкода.Справки2);
		
		ПараметрыВыбораСправки2 = Новый Структура;
		ПараметрыВыбораСправки2.Вставить("РежимВыбора",        Истина);
		ПараметрыВыбораСправки2.Вставить("ЗакрыватьПриВыборе", Истина);
		ПараметрыВыбораСправки2.Вставить("Отбор",              Отбор);
		
		ОткрытьФорму(
			"Справочник.Справки2ЕГАИС.ФормаВыбора",
			ПараметрыВыбораСправки2,
			Форма,,,,
			Новый ОписаниеОповещения("ВыборСправки2Завершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяУточнениеДанных Тогда
		
		ПараметрыЗавершенияВводаШтрихкода.Форма = Неопределено;
		Форма.КодМаркировкиДляУточнения = ПараметрыЗавершенияВводаШтрихкода;
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ОткрытьФормуУточненияДанных", 0.1, Истина);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции Тогда
		ШтрихкодированиеЕГАИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоАлкогольнойПродукции(Форма, ДанныеШтрихкода);
	КонецЕсли;
	
	Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
		И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Анализирует результат проверки на необходимость уточнения каких-либо данных у пользователя.
//
// Параметры:
//  РезультатОбработки - См. ШтрихкодированиеОбщегоНазначенияИС.ИнициализироватьРезультатОбработкиШтрихкода
// Возвращаемое значение:
//  Булево - Истина, если требуется уточнить какие-либо данные у пользователя.
Функция ТребуетсяУточнениеДанныхУПользователя(РезультатОбработки) Экспорт

	Возврат РезультатОбработки.ТребуетсяВыборСправки2;

КонецФункции

// Выполняет обработку выбора номенклатуры пользователем.
// 
// Параметры:
//  РезультатВыбора - Структура - результат выбора данных пользователем.
//  ДополнительныеПараметры - Структура - дополнительные параметры описание оповещения.
Процедура ВыборНоменклатурыЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Форма    = ДополнительныеПараметры.Форма;
	Действие = "ОбработатьВыборНоменклатуры";
	
	Если РезультатВыбора = Неопределено Тогда
		
		ПараметрыСканирования = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(Форма);
		
		Если ПараметрыСканирования.ВозможнаЗагрузкаТСД
			И Форма.ЗагрузкаДанныхТСД <> Неопределено Тогда
		
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПослеОбработкиШтрихкодаТСД", 0.1, Истина);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора.Номенклатура) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не указана номенклатура'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ВыполнитьДействие <> "" Тогда
		
		РезультатУточненияДанных = ШтрихкодированиеИСКлиент.ИнициализацияРезультатаУточненияДанныхДляВыполненияДальнейшихДействий();
		РезультатУточненияДанных.Действие                    = Действие;
		РезультатУточненияДанных.РезультатОбработкиШтрихкода = ДополнительныеПараметры.РезультатОбработкиШтрихкода;
		РезультатУточненияДанных.РезультатВыбора             = РезультатВыбора;
		РезультатУточненияДанных.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
		РезультатУточненияДанных.ИсходныеДанные              = ДополнительныеПараметры.ДанныеШтрихкода;
		РезультатУточненияДанных.ПараметрыСканирования       = ДополнительныеПараметры.ПараметрыСканирования;
		
		ОповещениеВыполнитьДействие = Новый ОписаниеОповещения(ДополнительныеПараметры.ВыполнитьДействие, Форма);
		ВыполнитьОбработкуОповещения(ОповещениеВыполнитьДействие, РезультатУточненияДанных);
		
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДополнительныеПараметры, "ОповещениеПриЗавершении")
		И ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.ПараметрыСканирования);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДополнительныеПараметры, "ЗавершениеОбработки")
		И ДополнительныеПараметры.ЗавершениеОбработки <> "" Тогда
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.ПараметрыСканирования);
		
		Если ДанныеШтрихкода.ТребуетсяУточнениеЧастичногоВыбытия Тогда
			
			ДополнительныеПараметры.РезультатОбработкиШтрихкода.ТребуетсяВыборНоменклатуры = Ложь;
			ДополнительныеПараметры.ДанныеШтрихкода = ДанныеШтрихкода;
			
			ЗавершитьОбработкуШтрихкода(ДополнительныеПараметры);
		
		Иначе
			
			ОповещениеЗавершениеОбработки = Новый ОписаниеОповещения(
				ДополнительныеПараметры.ЗавершениеОбработки, ДополнительныеПараметры.Форма, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеЗавершениеОбработки, ДанныеШтрихкода);
			
		КонецЕсли;
		
	Иначе
		
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ДополнительныеПараметры.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		
		ЗавершитьОбработкуШтрихкода(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку выбора справки 2 пользователем.
// 
// Параметры:
//  РезультатВыбора - Структура - результат выбора данных пользователем.
//  ДополнительныеПараметры - Структура - дополнительные параметры описание оповещения.
Процедура ВыборСправки2Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Действие = "ОбработатьВыборСправки2";
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если ДополнительныеПараметры.ВыполнитьДействие <> "" Тогда
		
		РезультатУточненияДанных = ШтрихкодированиеИСКлиент.ИнициализацияРезультатаУточненияДанныхДляВыполненияДальнейшихДействий();
		РезультатУточненияДанных.Действие                    = Действие;
		РезультатУточненияДанных.РезультатОбработкиШтрихкода = ДополнительныеПараметры.РезультатОбработкиШтрихкода;
		РезультатУточненияДанных.РезультатВыбора             = РезультатВыбора;
		РезультатУточненияДанных.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
		РезультатУточненияДанных.ИсходныеДанные              = ДополнительныеПараметры.ДанныеШтрихкода;
		РезультатУточненияДанных.ПараметрыСканирования       = ДополнительныеПараметры.ПараметрыСканирования;
		
		ОповещениеВыполнитьДействие = Новый ОписаниеОповещения(ДополнительныеПараметры.ВыполнитьДействие, Форма);
		ВыполнитьОбработкуОповещения(ОповещениеВыполнитьДействие, РезультатУточненияДанных);
		
	ИначеЕсли ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораСправки2(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
			
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	Иначе
		
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
			
		ДополнительныеПараметры.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		
		ЗавершитьОбработкуШтрихкода(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму с описанием ошибки о невозможности обработать отсканированный штрихкод.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой необходимо выполнить обработку штрихкода.
//  ПараметрыОткрытияФормы - (См. ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного)
//  ОповещениеОЗакрытии - ОписаниеОповещения - описание процедуры, выполняемой после закрытия информационного окна
Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы, Форма,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеПроверкиПередОбработкойШтрихкода(Штрихкод) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЕстьОшибки",  Ложь);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки", Неопределено);
	
	Если ТипЗнч(Штрихкод) <> Тип("Строка") Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Штрихкод не соответствует формату штрихкода акцизной марки'");
		ВозвращаемоеЗначение.ЕстьОшибки  = Истина;
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ВидПродукцииАлкогольнаяПродукция = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	ДанныеРазбора = РазборКодаМаркировкиИССлужебныйКлиент.РазобратьКодМаркировки(
		Штрихкод, ВидПродукцииАлкогольнаяПродукция);
	
	Если ДанныеРазбора = Неопределено
		Или ДанныеРазбора.ВидыУпаковокПоВидамПродукции[ВидПродукцииАлкогольнаяПродукция].Количество() = 0 Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Штрихкод не соответствует формату штрихкода акцизной марки'");
		ВозвращаемоеЗначение.ЕстьОшибки  = Истина;
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти
