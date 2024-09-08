﻿#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

// Дополняет параметры выбора статей и аналитик в документе.
//
// Параметры:
// 	МассивПаметровВыбора - Массив из См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики - 
// 	ПараметрыОпределенияДоступности - Структура:
// 	* ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации -
//	* ДокументОснование - ДокументСсылка - 
//	* ДатаДокумента - Дата - 
//	* ОтразитьНаПрочихДоходах - Булево -
//	* СписатьНаРасходы - Булево -
Процедура ДополнитьПараметрыВыбораСтатейИАналитик(МассивПаметровВыбора, ПараметрыОпределенияДоступности) Экспорт
	
	//++ Локализация
	Для каждого ЭлементМассива Из МассивПаметровВыбора Цикл
		
		Если (ЭлементМассива.ПутьКДанным = "Объект.Товары" И ЭлементМассива.Статья = "СтатьяРасходов") 
			ИЛИ (ЭлементМассива.ПутьКДанным = "Объект.Расхождения" И ЭлементМассива.Статья = "СтатьяРасходов")
			Или (ЭлементМассива.ПутьКДанным = "ТаблицаКорректировки" И ЭлементМассива.Статья = "СтатьяРасходов") Тогда
			ЭлементМассива.ВыборСтатьиДоходов = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	ДокументОснование = Объект.ДокументОснование;
	Если ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ПервичныйДокумент") Тогда
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьЗаполнениеКоличестваПоРНПТ(Объект, Отказ, Неопределено);
	КонецЕсли;
	
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") И ЗначениеЗаполнено(ДокументОснование)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ХозяйственнаяОперация") <> Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту Тогда
		
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьДанныеПрослеживаемостиНомеровГТД(Объект, Объект.Товары, Объект.Дата);
		
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//++ Локализация
	

	//-- Локализация
			
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-1
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ1";
		КомандаПечати.Представление = НСтр("ru='Акт о приеме-передаче ТМЦ на хранение (МХ-1)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-3
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ3";
		КомандаПечати.Представление = НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Возвращает данные для формирования печатной формы МХ - 1.
//
// Параметры:
//	ПараметрыПечати	- Структура -дополнительные настройки печати.
//	МассивОбъектов	- Массив из ДокументСсылка.КорректировкаПриобретения - коллекция значений ссылок на документы,
//																			по которым необходимо получить данные.
//
// Возвращаемое значение:
//	Структура - коллекция данных, используемых для печати, содержащая следующие следующие свойства:
//		* РезультатПоШапке			- РезультатЗапроса - данные шапки документа.
//		* РезультатПоСкладам		- РезультатЗапроса - данные о складе ответственного хранения.
//		* РезультатПоТабличнойЧасти	- РезультатЗапроса - данные табличной части документа.
//		* РезультатПоОшибкам		- РезультатЗапроса - данные об ошибках, возникающих при печати документа.
//
Функция ПолучитьДанныеДляПечатнойФормыМХ1(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка									КАК Ссылка,
	|	ДанныеДокумента.Номер									КАК Номер,
	|	ДанныеДокумента.Дата									КАК Дата,
	|	ДанныеДокумента.Дата									КАК ДатаДокумента,
	|	ДанныеДокумента.Организация								КАК Организация,
	|	ДанныеДокумента.Организация.Префикс						КАК Префикс,
	|	ТоварыДокумента.Склад									КАК Склад,
	|	ЕСТЬNULL(Склады.СкладОтветственногоХранения, ЛОЖЬ)		КАК СкладОтветственногоХранения,
	|	ДанныеДокумента.Организация = Склады.Поклажедержатель	КАК ОрганизацияПоклажедержатель,
	|	Склады.ИсточникИнформацииОЦенахДляПечати				КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены									КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены						КАК ВалютаЦены,
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет	КАК ПредварительныйРасчет,
	|	ДанныеДокумента.Дата									КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	Документ.КорректировкаПриобретения.Товары КАК ТоварыДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения КАК ДанныеДокумента
	|		ПО ТоварыДокумента.Ссылка = ДанныеДокумента.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|			И РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен
	|			И ДанныеДокумента.Организация = РасчетСебестоимостиТоваровОрганизации.Организация
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ТоварыДокумента.Склад = Склады.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Ссылка В(&МассивДокументов)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка								КАК Ссылка,
	|	ДанныеДокумента.Номер								КАК Номер,
	|	ДанныеДокумента.Дата								КАК Дата,
	|	ДанныеДокумента.ДатаДокумента						КАК ДатаДокумента,
	|	ДанныеДокумента.Организация							КАК Организация,
	|	ДанныеДокумента.Префикс								КАК Префикс,
	|	ДанныеДокумента.Склад								КАК Склад,
	|	ДанныеДокумента.ИсточникИнформацииОЦенахДляПечати	КАК ИсточникИнформацииОЦенахДляПечати,
	|	ДанныеДокумента.ВидЦены								КАК ВидЦены,
	|	ДанныеДокумента.ВалютаЦены							КАК ВалютаЦены,
	|	ДанныеДокумента.ПредварительныйРасчет				КАК ПредварительныйРасчет,
	|	ДанныеДокумента.ДатаПолученияСебестоимости			КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.СкладОтветственногоХранения
	|	И НЕ ДанныеДокумента.ОрганизацияПоклажедержатель
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Склад КАК Склад,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Серия КАК Серия,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения1 КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения1 КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения1 КАК ВидУпаковки,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Шапка.ВидЦены КАК ВидЦены,
	|	Шапка.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	Документ.КорректировкаПриобретения.Расхождения КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО Товары.Склад = Шапка.Склад
	|			И Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	|		ИЛИ (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|			И Шапка.ПредварительныйРасчет ЕСТЬ NULL))
	|	И (Товары.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУвеличитьСкладскиеОстатки)
	|		ИЛИ Товары.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУчестьПриИнвентаризации))
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
	|	ВидыЗапасов.Упаковка КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения2 КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения2 КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения2 КАК ВидУпаковки,
	|	ВидыЗапасов.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.КорректировкаПриобретения.Расхождения КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория = Шапка.Склад
	|			И ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|	И (ВидыЗапасов.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУвеличитьСкладскиеОстатки)
	|		ИЛИ ВидыЗапасов.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УвеличитьЗакупкуУчестьПриИнвентаризации))
	|;
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "ВидыЗапасов.Упаковка", "ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "ВидыЗапасов.Упаковка", "ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура"));
	
	СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке			= МассивРезультатов[МассивРезультатов.ВГраница() - 3];
	РезультатПоСкладам			= МассивРезультатов[МассивРезультатов.ВГраница() - 2];
	РезультатПоТабличнойЧасти	= МассивРезультатов[МассивРезультатов.ВГраница() - 1];
	РезультатПоОшибкам			= МассивРезультатов[МассивРезультатов.ВГраница()];
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке",			РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСкладам",			РезультатПоСкладам);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти",	РезультатПоТабличнойЧасти);
	СтруктураДанныхДляПечати.Вставить("РезультатПоОшибкам",			РезультатПоОшибкам);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

// Возвращает данные для формирования печатной формы МХ - 3.
//
// Параметры:
//	ПараметрыПечати	- Структура -дополнительные настройки печати.
//	МассивОбъектов	- Массив из ДокументСсылка.КорректировкаПриобретения - коллекция значений ссылок на документы,
//																			по которым необходимо получить данные.
//
// Возвращаемое значение:
//	Структура - коллекция данных, используемых для печати, содержащая следующие следующие свойства:
//		* РезультатПоШапке			- РезультатЗапроса - данные шапки документа.
//		* РезультатПоСкладам		- РезультатЗапроса - данные о складе ответственного хранения.
//		* РезультатПоТабличнойЧасти	- РезультатЗапроса - данные табличной части документа.
//		* РезультатПоОшибкам		- РезультатЗапроса - данные об ошибках, возникающих при печати документа.
//
Функция ПолучитьДанныеДляПечатнойФормыМХ3(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка									КАК Ссылка,
	|	ДанныеДокумента.Номер									КАК Номер,
	|	ДанныеДокумента.Дата									КАК Дата,
	|	ДанныеДокумента.Дата									КАК ДатаДокумента,
	|	ДанныеДокумента.Организация								КАК Организация,
	|	ДанныеДокумента.Организация.Префикс						КАК Префикс,
	|	ТоварыДокумента.Склад									КАК Склад,
	|	ЕСТЬNULL(Склады.СкладОтветственногоХранения, ЛОЖЬ)		КАК СкладОтветственногоХранения,
	|	ДанныеДокумента.Организация = Склады.Поклажедержатель	КАК ОрганизацияПоклажедержатель,
	|	Склады.ИсточникИнформацииОЦенахДляПечати				КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены									КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены						КАК ВалютаЦены,
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет	КАК ПредварительныйРасчет,
	|	ДанныеДокумента.Дата									КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	Документ.КорректировкаПриобретения.Товары КАК ТоварыДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения КАК ДанныеДокумента
	|		ПО ТоварыДокумента.Ссылка = ДанныеДокумента.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|			И РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен
	|			И ДанныеДокумента.Организация = РасчетСебестоимостиТоваровОрганизации.Организация
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ТоварыДокумента.Склад = Склады.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Ссылка В(&МассивДокументов)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка								КАК Ссылка,
	|	ДанныеДокумента.Номер								КАК Номер,
	|	ДанныеДокумента.Дата								КАК Дата,
	|	ДанныеДокумента.ДатаДокумента						КАК ДатаДокумента,
	|	ДанныеДокумента.Организация							КАК Организация,
	|	ДанныеДокумента.Префикс								КАК Префикс,
	|	ДанныеДокумента.Склад								КАК Склад,
	|	ДанныеДокумента.ИсточникИнформацииОЦенахДляПечати	КАК ИсточникИнформацииОЦенахДляПечати,
	|	ДанныеДокумента.ВидЦены								КАК ВидЦены,
	|	ДанныеДокумента.ВалютаЦены							КАК ВалютаЦены,
	|	ДанныеДокумента.ПредварительныйРасчет				КАК ПредварительныйРасчет,
	|	ДанныеДокумента.ДатаПолученияСебестоимости			КАК ДатаПолученияСебестоимости
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.СкладОтветственногоХранения
	|	И НЕ ДанныеДокумента.ОрганизацияПоклажедержатель
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Склад КАК Склад,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Серия КАК Серия,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения1 КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения1 КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения1 КАК ВидУпаковки,
	|	-Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	-Товары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Шапка.ВидЦены КАК ВидЦены,
	|	Шапка.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	Документ.КорректировкаПриобретения.Расхождения КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО Товары.Склад = Шапка.Склад
	|			И Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	|		ИЛИ (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|			И Шапка.ПредварительныйРасчет ЕСТЬ NULL))
	|	И (Товары.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУменьшитьСкладскиеОстатки)
	|		ИЛИ Товары.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУчестьПриИнвентаризации))
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
	|	ВидыЗапасов.Упаковка КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения2 КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения2 КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения2 КАК ВидУпаковки,
	|	ВидыЗапасов.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.КорректировкаПриобретения.Расхождения КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория = Шапка.Склад
	|			И ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|	И (ВидыЗапасов.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУменьшитьСкладскиеОстатки)
	|		ИЛИ ВидыЗапасов.ВариантОтражения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУчестьПриИнвентаризации))
	|;
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "ВидыЗапасов.Упаковка", "ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "ВидыЗапасов.Упаковка", "ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура"));
	
	СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке			= МассивРезультатов[МассивРезультатов.ВГраница() - 3];
	РезультатПоСкладам			= МассивРезультатов[МассивРезультатов.ВГраница() - 2];
	РезультатПоТабличнойЧасти	= МассивРезультатов[МассивРезультатов.ВГраница() - 1];
	РезультатПоОшибкам			= МассивРезультатов[МассивРезультатов.ВГраница()];
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке",			РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСкладам",			РезультатПоСкладам);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти",	РезультатПоТабличнойЧасти);
	СтруктураДанныхДляПечати.Вставить("РезультатПоОшибкам",			РезультатПоОшибкам);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции
//-- Локализация
#КонецОбласти


// Заполняет массив допустимых наименований входящих документов.
//
// Параметры:
//  МассивНаименований	 - Массив - массив наименования входящих документов.
//
Процедура ДополнитьНаименованияВходящихДокументов(МассивНаименований) Экспорт
	//++ Локализация
	МассивНаименований.Добавить(НСтр("ru='УПД'"));
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры
//++ Локализация


//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация


//-- Локализация
#КонецОбласти

#КонецОбласти
