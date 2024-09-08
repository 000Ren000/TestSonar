﻿#Область ПрограммныйИнтерфейс

// Обработчик команды формы, требующей контекстного вызова сервера.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой выполняется команда.
//   ПараметрыВызова - Структура - параметры вызова.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//   Результат - Структура - результат выполнения команды.
//
Процедура ВыполнитьПереопределяемуюКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФорм

// Серверная переопределяемая процедура, вызываемая при заполнении реквизитов формы созданных ИСМП (при открытии)
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//
Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(Форма.ИмяФормы,"Документ.ЧекККМ.")
		Или СтрНачинаетсяС(Форма.ИмяФормы,"Документ.ЧекККМВозврат.")
		Или СтрНачинаетсяС(Форма.ИмяФормы,"Справочник.ШаблоныЭтикетокИЦенников.") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИнтеграции = Неопределено;
	Для Каждого ВидПродукции Из ОбщегоНазначенияИСКлиентСервер.ВидыПродукцииИСМП(Истина) Цикл
		ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить(ВидПродукции);
		Если ПараметрыИнтеграции <> Неопределено Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыИнтеграции = Неопределено Тогда
		ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ФормаСверкиИСМП");
		Если ПараметрыИнтеграции = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Количество0 = 0;
	УчитываемыеВидыМаркируемойПродукции = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
	Если УчитываемыеВидыМаркируемойПродукции.Найти(Перечисления.ВидыПродукцииИС.ПустаяСсылка()) <> Неопределено Тогда
		Количество0 = 1;
	КонецЕсли;
	
	Если ПараметрыИнтеграции = Неопределено
		Или ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции().Количество() = Количество0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыИнтеграции) = Тип("Массив")
		И ПараметрыИнтеграции.Количество() Тогда
		ПараметрыИнтеграции = ПараметрыИнтеграции[0];
	КонецЕсли;
	
	Если ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		
		Объект = ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект;
		Товары = ПараметрыИнтеграции.ИмяТабличнойЧастиТовары;
		
		ПараметрыЗаполненияРеквизитов = Новый Структура;
		ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
		ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
		НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Форма[Объект][Товары],ПараметрыЗаполненияРеквизитов);
		Если ПроверкаИПодборПродукцииИСМП.ПараметрыИнтеграцииФормыПроверкиИПодбора(Форма, ВидПродукции).ДоступныОбъемноСортовыеКоды Тогда
			ПроверкаИПодборПродукцииИСМП.ЗаполнитьПризнакАвтоматическийОСУИСВТаблице(Форма[Объект][Товары])
		КонецЕсли;
		
		Для Каждого СтрокаТаблицы Из Форма[Объект][Товары] Цикл
			Если СтрокаТаблицы.МаркируемаяПродукция И СтрокаТаблицы.ВидПродукцииИС = Перечисления.ВидыПродукцииИС.Алкогольная Тогда
				СтрокаТаблицы.МаркируемаяПродукция = Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ПараметрыИнтеграции.Свойство("ИспользоватьКолонкуРасхожденияПоКодамМаркировки")
		И ПараметрыИнтеграции.ИспользоватьКолонкуРасхожденияПоКодамМаркировки Тогда
		
		Объект = ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект;
		Товары = ПараметрыИнтеграции.ИмяТабличнойЧастиТовары;
		
		ИмяКолонкиРасхождения                = ПараметрыИнтеграции.ИмяКолонкиРасхождения;
		Расхождения                          = ПараметрыИнтеграции.ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения;
		ДоступноСогласованиеРасхождений      = ПараметрыИнтеграции.ДоступноСогласованиеРасхождений;
		
		СверкаКодовМаркировкиИСМП.ЗаполнитьКолонкуРасхожденияПоКодамМаркировки(
			Форма[Объект][Товары],
			Форма[Объект][Расхождения],
			ИмяКолонкиРасхождения,
			ДоступноСогласованиеРасхождений);
		Если ДоступноСогласованиеРасхождений Тогда
			ТребуетсяОбработкаКодовМаркировки = Ложь;
			СверкаКодовМаркировкиИСМППереопределяемый.ПриОпределенииНеобходимостиОбработкиКодовМаркировкиВДокументе(
				Форма[Объект],
				ПараметрыИнтеграции,
				ТребуетсяОбработкаКодовМаркировки);
			Форма[ПараметрыИнтеграции.ИмяРеквизитаФормыТребуетсяОбработкаКодовМаркировки] =ТребуетсяОбработкаКодовМаркировки;
		КонецЕсли;
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределение параметров интеграции ИСМП (расположения команды проверки и подбора)
//
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   СтандартнаяОбработка - Булево - стандартная работа с элементами проверки подбора
//   ПараметрыИнтеграции  - Соответствие - автоматически заданные параметры интеграции
//
Процедура ПриОпределенииПараметровИнтеграции(Форма, СтандартнаяОбработка, ПараметрыИнтеграции) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ПомощникНового"
		Или Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников" Тогда
			СтандартнаяОбработка = Ложь;
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
			СтандартнаяОбработка = Ложь;
	ИначеЕсли Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента"
		Тогда
			СтандартнаяОбработка = Ложь;
	ИначеЕсли Форма.ИмяФормы = "Документ.ПрочееОприходованиеТоваров.Форма.ФормаДокумента"

		Тогда
		
		ВидыПродукцииИСМП = ПараметрыИнтеграции.Получить("ИСМП").ВидыПродукции;
		Если ВидыПродукцииИСМП.Найти(Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС) = Неопределено Тогда
			СтандартнаяОбработка = Ложь;
		Иначе
			ВидыПродукцииИСМП = Новый Массив;
			ВидыПродукцииИСМП.Добавить(Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС);
			ПараметрыИнтеграции.Получить("ИСМП").ВидыПродукции = ВидыПродукцииИСМП;
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

//Переопределение параметров интеграции ИСМП (расположения форматированной строки перехода к связанному объекту)
//
//Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   ПараметрыНадписи - Структура        - (см. СобытияФормИСМП.ПараметрыИнтеграцииГиперссылкиИСМП)
//
Процедура ПриОпределенииПараметровИнтеграцииГиперссылкиИСМП(Форма, ПараметрыНадписи) Экспорт
	
	//++ НЕ ГОСИС
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
		И ТипЗнч(Форма.Объект) = Тип("ДанныеФормыСтруктура")
		И ИнтеграцияИСМП.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
		
		ПараметрыНадписи.Вставить("ИмяЭлементаФормы",  "ТекстДокументаИСМП");
		ПараметрыНадписи.Вставить("ИмяРеквизитаФормы", "ТекстДокументаИСМП");
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ГруппаСостояние")
		Тогда
		ПараметрыНадписи.РазмещениеВ = "ГруппаСостояние";
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределение доступности интеграции формы сверки для прикладной формы (расположения форматированной строки перехода к связанному объекту)
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   СтандартнаяОбработка - Булево - установить ложь, если требуется отменить выполнение стандартной обработки.
//
Процедура ПриОпределенииДоступностиИнтеграцииФормыСверкиКодовМаркировки(Форма, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	
	Если Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаПриобретения.Форма.ФормаДокумента"
		Тогда
		СтандартнаяОбработка = Истина;
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	//-
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуРМК(Форма);
	
	ИначеЕсли Форма.ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента" Тогда
		
		СобытияФормИСМПКлиентСервер.ДополнительныеПараметрыИнтеграции(Форма, Истина);
		
	КонецЕсли;
	


	Если Форма.ИмяФормы = "Документ.ПрочееОприходованиеТоваров.Форма.ФормаДокумента" Тогда
		ИнтеграцияИСУТ.ДобавитьКомандуЗаполненияПоОтчетамПроизводственнойЛинии(Форма);
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма         - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  ТекущийОбъект - ДокументОбъект - объект, который будет прочитан.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	//++ НЕ ГОСИС
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуРМК(Форма);
		
	ИначеЕсли ИмяФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента" Тогда
		
		ИнтеграцияИСМПУТКлиентСервер.ДополнитьНадписьСпособаОтраженияРасхождений(
			ТипЗнч(Форма.Объект.Ссылка),
			Форма.Элементы.НадписьРасхождения,
			Форма.Элементы.ОформитьДокументы,
			Форма.Объект.Товары,
			Форма.Объект.ШтрихкодыУпаковокРасхождения);
		
	КонецЕсли;
	


	Если Форма.ИмяФормы = "Документ.ПрочееОприходованиеТоваров.Форма.ФормаДокумента" Тогда
		ИнтеграцияИСУТ.ДобавитьКомандуЗаполненияПоОтчетамПроизводственнойЛинии(Форма);
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента" 
		Или Форма.ИмяФормы = "Документ.РасходныйОрдерНаТовары.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ПриходныйОрдерНаТовары.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ОтборРазмещениеТоваров.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" Тогда
		
		ПроверкаИПодборПродукцииИСМП.ПрименитьКешШтрихкодовУпаковок(Форма, Истина);
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Элемент = "Событие" И СтрНачинаетсяС(ДополнительныеПараметры.ИмяСобытия,"ЗакрытиеФормыПроверкиИПодбораГосИС") Тогда
			
			ИндексВидаПродукции     = Число(СтрЗаменить(ДополнительныеПараметры.ИмяСобытия, "ЗакрытиеФормыПроверкиИПодбораГосИС", ""));
			ВидМаркируемойПродукции = ОбщегоНазначенияИСКлиентСервер.ИндексВидаПродукцииИС(ИндексВидаПродукции);
				
			ПроверкаИПодборПродукцииИСМПУТ.ПриЗакрытииФормыПроверкиИПодбораВФормеРМК(
				Форма,
				ДополнительныеПараметры.Параметр,
				ВидМаркируемойПродукции);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыВыбора

// Устанавливает параметры выбора шаблона этикетки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора,
//  ИмяПоляВвода - Строка - имя поля ввода шаблона этикетки.
Процедура УстановитьПараметрыВыбораШаблонаЭтикетки(Форма,  ИмяПоляВвода) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора, Ложь);
	
	Назначение = ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП");
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Назначение", Назначение));
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Устанавливает параметры выбора контрагента.
//
//Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора.
//   ТолькоЮрЛицаНерезиденты - Неопределено, Булево - Признак нерезидента.
//   ИмяПоляВвода            - Строка               - имя поля ввода номенклатуры.
//
Процедура УстановитьПараметрыВыбораКонтрагента(Форма, ТолькоЮрЛицаНерезиденты = Неопределено, ИмяПоляВвода = "Контрагент") Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = Новый Массив();
	Для Каждого ПараметрВыбора Из Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя <> "Отбор.ЮрФизЛицо" Тогда
			ПараметрыВыбора.Добавить(ОбщегоНазначения.СкопироватьРекурсивно(ПараметрВыбора, Ложь));
		КонецЕсли;
	КонецЦикла;
	
	Если ТолькоЮрЛицаНерезиденты = Истина Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ЮрФизЛицо", Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент));
	ИначеЕсли ТолькоЮрЛицаНерезиденты = Ложь Тогда
		МассивДанных = Новый Массив();
		Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ЮрФизЛицо.ЗначенияПеречисления Цикл
			Если ЗначениеПеречисления <> Метаданные.Перечисления.ЮрФизЛицо.ЗначенияПеречисления.Найти("ЮрЛицоНеРезидент") Тогда
				МассивДанных.Добавить(Перечисления.ЮрФизЛицо[ЗначениеПеречисления.Имя]);
			КонецЕсли;
		КонецЦикла;
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ЮрФизЛицо", ОбщегоНазначения.СкопироватьРекурсивно(МассивДанных)));
	КонецЕсли;
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыВыбора, Истина);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет действия при изменении номенклатуры в строке табличной части.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - редактируемая строка таблицы,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - Структура - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Количество = Неопределено;
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Характеристика") Тогда
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",
			ТекущаяСтрока.Характеристика);
			
		СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТипНоменклатуры") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",
			Новый Структура("Номенклатура", "ТипНоменклатуры"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		
		ПараметрыУказанияСерийКопия = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыУказанияСерий, Ложь);
		Склад = Неопределено;
		Если ПараметрыУказанияСерийКопия <> Неопределено Тогда
			
			ИмяТЧ = "Товары";
			ИмяПоляСклад = "Склад";
			Если ПараметрыУказанияСерийКопия.Свойство("ВыходныеИзделия") Тогда
				ПараметрыУказанияСерийКопия = ПараметрыУказанияСерийКопия.ВыходныеИзделия;
				ИмяТЧ = "ВыходныеИзделия";
				ИмяПоляСклад = "Получатель";
			КонецЕсли;
			
			ИсточникЗначенийВФорме = Форма;
			Если ПараметрыУказанияСерийКопия.ИмяИсточникаЗначенийВФормеОбъекта = "ТекущиеДанные" Тогда
				ИсточникЗначенийВФорме = ТекущаяСтрока;
			ИначеЕсли ЗначениеЗаполнено(ПараметрыУказанияСерийКопия.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
				ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерийКопия.ИмяИсточникаЗначенийВФормеОбъекта];
			КонецЕсли;
	
			Если СтрНачинаетсяС(Форма.ИмяФормы, "Обработка.ПроверкаИПодбор") Тогда
				ПараметрыУказанияСерийКопия.ИмяТЧТовары = ИмяТЧ;
				ПараметрыУказанияСерийКопия.ИмяТЧСерии = ИмяТЧ;
				ИнтеграцияИСУТКлиентСервер.ПараметрыУказанияСерийЗаменитьИмяТЧ(ПараметрыУказанияСерийКопия);
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Удалить(
					ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Найти("КоличествоПодобрано"));
				ТекущаяСтрока[ИмяПоляСклад] = Форма.Склад;
				// Количество сохраняется и восстановливается при завершении обработки
				// для корректного расчета статусов указания серий.
				Количество = ТекущаяСтрока.Количество;
				ТекущаяСтрока.Количество = ТекущаяСтрока.КоличествоПодобрано;
				Склад = Форма.Склад;
			ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "ОбщаяФорма.УточнениеСоставаУпаковкиИС") Тогда
				ПараметрыУказанияСерийКопия.ИмяТЧТовары = ИмяТЧ;
				ПараметрыУказанияСерийКопия.ИмяТЧСерии = ИмяТЧ;
				ИнтеграцияИСУТКлиентСервер.ПараметрыУказанияСерийЗаменитьИмяТЧ(ПараметрыУказанияСерийКопия);
				ТекущаяСтрока[ИмяПоляСклад] = Форма.Склад;
			ИначеЕсли Не ПустаяСтрока(ПараметрыУказанияСерийКопия.ИмяПоляСклад) Тогда
				Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерийКопия.ИмяПоляСклад];
			КонецЕсли;
			
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
			Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерийКопия, Склад));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Артикул") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Код") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакКод", Новый Структура("Номенклатура", "Код"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмерения") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		ПараметрыДействия = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС();
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыДействия, Форма.Объект);
		Иначе
			ЗаполнитьЗначенияСвойств(ПараметрыДействия, Форма);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПараметрыДействия, ТекущаяСтрока);
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ПараметрыДействия);
	КонецЕсли;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Сумма") Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		Если ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковок) Тогда
			СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		Иначе
			СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда
		СтруктураДействий.Вставить("ЗаполнитьКодТНВЭД");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТребуетВзвешивания") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакТребуетВзвешивания", Новый Структура("Номенклатура", "ТребуетВзвешивания"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ПроизвольнаяЕдиницаУчета") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакПроизвольнаяЕдиницаУчета", Новый Структура("Номенклатура", "ПроизвольнаяЕдиницаУчета"));
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если Количество <> Неопределено Тогда
		
		ТекущаяСтрока.Количество = Количество;
		// Для обхода ошибки расчета статуса указания серий
		Если ТекущаяСтрока.СтатусУказанияСерий = 1
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 2;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 3
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 4;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 5
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 6;
		ИначеЕсли ТекущаяСтрока.СтатусУказанияСерий = 7
			И ЗначениеЗаполнено(ТекущаяСтрока.Серия) Тогда
			ТекущаяСтрока.СтатусУказанияСерий = 8;
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества (поле КоличествоУпаковок) в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества (поле Количество) в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличестваЕдиниц(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		
		ПараметрыУказанияСерийКопия = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыУказанияСерий, Ложь);
		ИмяТЧ = "Товары";
		Если ПараметрыУказанияСерийКопия.Свойство("ВыходныеИзделия") Тогда
			ПараметрыУказанияСерийКопия = ПараметрыУказанияСерийКопия.ВыходныеИзделия;
			ИмяТЧ = "ВыходныеИзделия";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыУказанияСерийКопия.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
			ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерийКопия.ИмяИсточникаЗначенийВФормеОбъекта];
		Иначе
			ИсточникЗначенийВФорме = Форма;
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПараметрыУказанияСерийКопия.ИмяПоляСклад) Тогда
			
			Если СтрНачинаетсяС(Форма.ИмяФормы, "Обработка.ПроверкаИПодбор") Тогда
				ПараметрыУказанияСерийКопия.ИмяТЧТовары = ИмяТЧ;
				ПараметрыУказанияСерийКопия.ИмяТЧСерии = ИмяТЧ;
				ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Удалить(
					ПараметрыУказанияСерийКопия.ИменаПолейДополнительные.Найти("КоличествоПодобрано"));
				Склад = Форма.Склад;
			Иначе
				Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
			КонецЕсли;
			
			СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
				Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерийКопия, Склад));
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Заполняет табличную часть Товары подобранными товарами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
//  ПараметрыЗаполнения - Структура - дополнительные параметры заполнения
//  ПараметрыЗаполнения - Структура - параметры заполнения,
//  КэшированныеЗначения - Неопределено, Структура - сохраненные значения параметров, используемых при обработке,
//  ДобавленныеСтроки - Неопределено, Массив из ДанныеФормыЭлементКоллекции - массив добавленных строк таблицы товаров
Процедура ОбработкаРезультатаПодбораНоменклатуры(
	Форма, ВыбранноеЗначение, ПараметрыЗаполнения,
	КэшированныеЗначения = Неопределено, ДобавленныеСтроки = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	ИспользуютсяУпаковки = Истина;
	Если ПараметрыЗаполнения.Свойство("ИспользуютсяУпаковки") Тогда
		ИспользуютсяУпаковки = ПараметрыЗаполнения.ИспользуютсяУпаковки;
	КонецЕсли;
	
	ПараметрыУказанияСерий = Неопределено;
	ПараметрыЗаполнения.Свойство("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
	
	ИмяТабличнойЧасти = "Товары";
	ТекущаяСтрока     = Неопределено;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		Если Не ИспользуютсяУпаковки Тогда
			СтрокаТовара.КоличествоУпаковок = СтрокаТовара.Количество;
			СтрокаТовара.Упаковка = Неопределено;
		КонецЕсли;
		
		ТекущаяСтрока = Форма.Объект[ИмяТабличнойЧасти].Добавить();
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий);
		
		Если ДобавленныеСтроки <> Неопределено Тогда
			ДобавленныеСтроки.Добавить(ТекущаяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти
