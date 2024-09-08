﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	ТипИзмеряемойВеличины = Параметры.ТипИзмеряемойВеличины;
	УпаковкиИспользуются = ИнтеграцияИС.УпаковкиИспользуются();
	
	Если Параметры.РежимВыбора Тогда
		НастроитьСписокДляВыбора();
		Элементы.ОтборСтрок.Видимость = Истина;
		ОтборСтрок = "Рекомендуемые";
	Иначе
		УстановитьБыстрыйОтборСервер();
		ИнтеграцияСАТУРНКлиентСервер.НастроитьОтборПоОрганизации(ЭтотОбъект, ОрганизацииСАТУРН, "", "");
		Элементы.ОтборСтрок.Видимость = Ложь;
	КонецЕсли;
	
	НастроитьЗапросСписка();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
		
	Если ИмяСобытия = "Запись_КлассификаторОрганизацийСАТУРН" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ОрганизацииСАТУРН, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Истина, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтборСтрокПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Рекомендуемые", ОтборСтрок = "Рекомендуемые", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ДанныеСписка           = ДанныеСписка(Строки);
	МестаХраненияСклады    = ДанныеСписка.МестаХраненияСклады;
	
	ЦветТребуетВнимания    = ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС;
	
	Для Каждого Строка Из Строки Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Партия) Тогда
			
			Оформление = Строка.Значение.Оформление["Партия"];
			
			Если Оформление <> Неопределено Тогда
				
				Если Не ЗначениеЗаполнено(Строка.Значение.Данные.НомерПартии) Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", Строка.Значение.Данные.Партия);
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст", Строка.Значение.Данные.НомерПартии);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.ОрганизацияСАТУРН) Тогда
			
			Оформление = Строка.Значение.Оформление.Получить("ОрганизацияСАТУРН");
			Если Оформление <> Неопределено Тогда
				
				Если Не ЗначениеЗаполнено(Строка.Значение.Данные.КонтрагентОрганизация) Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 <не сопоставлен>'"), Строка.Значение.Данные.ОрганизацияСАТУРН));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст",  СтрШаблон(НСтр("ru = '%1 (%2)'"), Строка.Значение.Данные.ОрганизацияСАТУРН, Строка.Значение.Данные.КонтрагентОрганизация));
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.МестоХранения) Тогда
			
			Оформление = Строка.Значение.Оформление.Получить("МестоХранения");
			Если Оформление <> Неопределено Тогда
				Данные = МестаХраненияСклады[Строка.Значение.Данные.МестоХранения];
				
				Если Данные = Неопределено Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", НСтр("ru = '<не сопоставлен>'"));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				ИначеЕсли Не ЗначениеЗаполнено(Данные) Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 <не сопоставлен>'"), Строка.Значение.Данные.МестоХранения));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст",  СтрШаблон(НСтр("ru = '%1 (%2)'"), Строка.Значение.Данные.МестоХранения, Данные));
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора
		Или ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если Поле.Имя = Элементы.СписокМестоХранения.Имя Тогда
		
		Если ЗначениеЗаполнено(ДанныеСтроки.МестоХранения) Тогда
			
			ПоказатьЗначение(, ДанныеСтроки.МестоХранения);
			
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = Элементы.СписокОрганизация.Имя Тогда
		
		Если ЗначениеЗаполнено(ДанныеСтроки.ОрганизацияСАТУРН) Тогда
			
			ПоказатьЗначение(, ДанныеСтроки.ОрганизацияСАТУРН);
			
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = Элементы.СписокПартия.Имя Тогда
		
		Если ЗначениеЗаполнено(ДанныеСтроки.Партия) Тогда
			
			ПоказатьЗначение(, ДанныеСтроки.Партия);
			
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = Элементы.СписокПАТ.Имя Тогда
		
		Если ЗначениеЗаполнено(ДанныеСтроки.ПАТ) Тогда
			
			ПоказатьЗначение(, ДанныеСтроки.ПАТ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина) Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если УпаковкиИспользуются И ЗначениеЗаполнено(ТипИзмеряемойВеличины) Тогда
			Если Не ЗначениеЗаполнено(КоэффициентПересчетаВУпаковкуКилограммы) 
				И ТекущиеДанные.ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Вес") Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Недоступно использование партий в килограммах: нет пересчета из единицы хранения номенклатуры'"),,"Список");
					Возврат;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(КоэффициентПересчетаВУпаковкуЛитры) 
				И ТекущиеДанные.ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Объем") Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Недоступно использование партий в литрах: нет пересчета из единицы хранения номенклатуры'"),,"Список");
					Возврат;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ТекущиеДанные.ТипИзмеряемойВеличины)
				И КоэффициентПересчетаВУпаковкуЛитры <> КоэффициентПересчетаВУпаковкуКилограммы
				И КоэффициентПересчетаВУпаковкуЛитры > 0
				И КоэффициентПересчетаВУпаковкуКилограммы > 0 Тогда
					ПредложитьВыбратьТипПартии();
					Возврат;
			КонецЕсли;
		КонецЕсли;
		ОповеститьОВыборе(ИнтеграцияСАТУРНКлиентСервер.РезультатВыбораПартииСАТУРН(ТекущиеДанные));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СписокСтатусов = Новый СписокЗначений();
	СписокСтатусов.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Архив);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Отменен);
	СписокСтатусов.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Черновик);
	
	// Выделение цветом элементов статусах неактивности
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	// Отображение незаполненной даты производства
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаПроизводства.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДатаПроизводства");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не указано>'"));
	
	// Отображение незаполненного срока годности
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СрокГодности.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СрокГодности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не указано>'"));
	
	// Отображение несовместимого с упаковками номенклатуры типа измеряемой величины партии
	
	//Нет пересчета в килограммы
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДоступныйОстатокУпаковок.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуКилограммы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УпаковкиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипИзмеряемойВеличины");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.Вес;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Недоступно>'"));
	 
	//Нет пересчета в литры
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДоступныйОстатокУпаковок.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуЛитры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УпаковкиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипИзмеряемойВеличины");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.Объем;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Недоступно>'"));
	
	//Неизвестный тип упаковки, разные коэффициенты
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДоступныйОстатокУпаковок.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуЛитры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуКилограммы");
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуЛитры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КоэффициентПересчетаВУпаковкуКилограммы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УпаковкиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипИзмеряемойВеличины");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.ПустаяСсылка();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Неизвестно>'"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеСписка(Строки)
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("МестаХраненияСклады",    Новый Соответствие());
	
	МестаХраненияСклады    = Новый Соответствие;
	КлючиМестХранения      = Новый Массив;
	
	Для Каждого Строка Из Строки Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.МестоХранения) Тогда
			Если КлючиМестХранения.Найти(Строка.Значение.Данные.МестоХранения) = Неопределено Тогда
				КлючиМестХранения.Добавить(Строка.Значение.Данные.МестоХранения);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МестаХраненияСАТУРН.Ссылка КАК МестоХранения,
		|	КлассификаторОрганизацийСАТУРНМестаХранения.ТорговыйОбъект.Представление КАК МестоХраненияСклад
		|ИЗ
		|	Справочник.МестаХраненияСАТУРН КАК МестаХраненияСАТУРН
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийСАТУРН.МестаХранения КАК
		|			КлассификаторОрганизацийСАТУРНМестаХранения
		|		ПО КлассификаторОрганизацийСАТУРНМестаХранения.МестоХранения = МестаХраненияСАТУРН.Ссылка
		|ГДЕ
		|	МестаХраненияСАТУРН.Ссылка В (&МассивСсылок)
		|ИТОГИ
		|ПО
		|	МестоХранения";
	
	Запрос.УстановитьПараметр("МассивСсылок", КлючиМестХранения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаМестоХранения = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаМестоХранения.Следующий() Цикл
		
		ВыборкаДетальныеЗаписи = ВыборкаМестоХранения.Выбрать();
		МассивСкладов          = Новый Массив;
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			МассивСкладов.Добавить(ВыборкаДетальныеЗаписи.МестоХраненияСклад);
			
		КонецЦикла;
		
		Если МассивСкладов.Количество() = 0 Тогда
			Продолжить;
		ИначеЕсли МассивСкладов.Количество() = 1 Тогда
			
			МестаХраненияСклады.Вставить(ВыборкаМестоХранения.МестоХранения, МассивСкладов[0]);
			
		Иначе
			
			ШаблонСтроки = НСтр("ru = '%1 ( + еще %2 )'");
			МестаХраненияСклады.Вставить(ВыборкаМестоХранения.МестоХранения,
				СтрШаблон(ШаблонСтроки, МассивСкладов[0], МассивСкладов.Количество() - 1));
			
		КонецЕсли;
	
	КонецЦикла;

	СтруктураВозврата.МестаХраненияСклады    = МестаХраненияСклады;
	
	Возврат СтруктураВозврата;

КонецФункции

&НаСервере
Процедура НастроитьЗапросСписка()
	
	Список.Параметры.УстановитьЗначениеПараметра("ТипИзмеряемойВеличины", ТипИзмеряемойВеличины);
	Список.Параметры.УстановитьЗначениеПараметра("КоэффициентВес", 
		?(КоэффициентПересчетаВУпаковкуКилограммы = 0, 0, 1/КоэффициентПересчетаВУпаковкуКилограммы));
	Список.Параметры.УстановитьЗначениеПараметра("КоэффициентОбъем", 
		?(КоэффициентПересчетаВУпаковкуЛитры = 0, 0, 1/КоэффициентПересчетаВУпаковкуЛитры));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокДляВыбора()
	
	Элементы.Список.РежимВыбора = Истина;
	Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Одиночный;
	
	Элементы.ГруппаОтбор.Видимость = Ложь;
	Элементы.СписокОрганизация.Видимость   = Не ЗначениеЗаполнено(Параметры.ОрганизацияСАТУРН);
	Элементы.СписокМестоХранения.Видимость = Не ЗначениеЗаполнено(Параметры.МестоХранения);
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		Элементы.СписокДоступныйОстатокУпаковок.Видимость = Истина;
		Элементы.СписокДоступныйОстатокУпаковок.Заголовок = СтрШаблон(
			НСтр("ru = 'Доступный остаток, %1 %2'"), Параметры.Номенклатура, Параметры.Упаковка);
		НаименованиеУпаковки = Параметры.Упаковка;
	КонецЕсли;
	НаименованиеУпаковки = Параметры.Упаковка;
	
	НастроитьОтборСпискаДляВыбора();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтборСпискаДляВыбора()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Статус", Перечисления.СтатусыОбъектовСАТУРН.Актуально, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ОрганизацияСАТУРН", Параметры.ОрганизацияСАТУРН,,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"МестоХранения", Параметры.МестоХранения,,, ЗначениеЗаполнено(Параметры.МестоХранения));
	
	ЗаполненоОКПД2 = ЗначениеЗаполнено(Параметры.ОКПД2); 
	Если ЗаполненоОКПД2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ОКПД2", Параметры.ОКПД2, ВидСравненияКомпоновкиДанных.НачинаетсяС,, Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ДоступныйОстаток", 0, ВидСравненияКомпоновкиДанных.Больше,, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Параметры.Номенклатура, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Характеристика", Параметры.Характеристика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Серия", Параметры.Серия, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПАТ", Параметры.ПАТ, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненаНоменклатура", ЗначениеЗаполнено(Параметры.Номенклатура), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненПАТ", ЗначениеЗаполнено(Параметры.ПАТ), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненаСерия", ЗначениеЗаполнено(Параметры.Серия), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатурыВЕТИС"), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Рекомендуемые", Истина, Истина);
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		
		Если Параметры.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличинСАТУРН.Вес Тогда
			КоэффициентПересчетаВУпаковкуКилограммы = Параметры.КоличествоВУпаковкеСАТУРН;
		Иначе
			КоэффициентПересчетаВУпаковкуЛитры = Параметры.КоличествоВУпаковкеСАТУРН;
		КонецЕсли;
		
		Коэффициенты = ИнтеграцияИСВызовСервера.КоэффициентВесОбъемУпаковки(
			Параметры.Номенклатура, Параметры.Упаковка, Неопределено);
		Если Коэффициенты.Вес > 0 Тогда
			КоэффициентПересчетаВУпаковкуКилограммы = Коэффициенты.Вес;
		КонецЕсли;
		Если Коэффициенты.Объем > 0 Тогда
			КоэффициентПересчетаВУпаковкуЛитры = Коэффициенты.Объем;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросПартийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("ОрганизацииСАТУРН",              ОрганизацииСАТУРН);
		СтруктураБыстрогоОтбора.Свойство("ОрганизацияСАТУРН",              ОрганизацияСАТУРН);
		СтруктураБыстрогоОтбора.Свойство("ОрганизацииСАТУРНПредставление", ОрганизацииСАТУРНПредставление);
		
		ИнтеграцияСАТУРНКлиентСервер.УстановитьОтборыДинамическогоСпискаПоОрганизацииСАТУРН(ЭтотОбъект);
		
	ИначеЕсли Параметры.Отбор.Свойство("ОрганизацияСАТУРН") Тогда
		
		Параметры.Отбор.Свойство("ОрганизацияСАТУРН", ОрганизацияСАТУРН);
		
		ОрганизацииСАТУРН.Добавить(ОрганизацияСАТУРН);
		МестоХранения = Неопределено;
		
		Если Параметры.Отбор.Свойство("МестоХранения") Тогда
			МестоХранения = Параметры.Отбор.МестоХранения;
		КонецЕсли;
		
		ОрганизацииСАТУРНПредставление = СтрШаблон(НСтр("ru = '%1 (%2)'"), Строка(ОрганизацияСАТУРН), Строка(МестоХранения));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ОрганизацияСАТУРН", ОрганизацияСАТУРН,,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"МестоХранения", МестоХранения,,, ЗначениеЗаполнено(МестоХранения));
		
	КонецЕсли;
	
	СобытияФормСАТУРН.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьВыбратьТипПартии()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	КоличествоВес = Окр(ТекущиеДанные.ДоступныйОстаток / КоэффициентПересчетаВУпаковкуКилограммы, 3);
	КоличествоОбъем = Окр(ТекущиеДанные.ДоступныйОстаток / КоэффициентПересчетаВУпаковкуЛитры, 3);
	
	СписокВыбора = Новый СписокЗначений;
	Ключ = Новый Структура("ТипИзмеряемойВеличины, КоличествоВУпаковкеСАТУРН", ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Вес"), 1/КоэффициентПересчетаВУпаковкуКилограммы);
	СписокВыбора.Добавить(Ключ, СтрШаблон(НСтр("ru = 'Партия в килограммах (%1 %2)'"), КоличествоВес, НаименованиеУпаковки));
	Ключ = Новый Структура("ТипИзмеряемойВеличины, КоличествоВУпаковкеСАТУРН", ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Объем"), 1/КоэффициентПересчетаВУпаковкуЛитры);
	СписокВыбора.Добавить(Ключ, СтрШаблон(НСтр("ru = 'Партия в литрах (%1 %2)'"), КоличествоОбъем, НаименованиеУпаковки));
	СписокВыбора.Добавить(КодВозвратаДиалога.Отмена);
	Оповещение = Новый ОписаниеОповещения("ПриВыбореТипаПартии", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Укажите тип единицы измерения выбранной партии'"), СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореТипаПартии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	РезультатВыбораПартии = ИнтеграцияСАТУРНКлиентСервер.РезультатВыбораПартииСАТУРН(ТекущиеДанные);
	ЗаполнитьЗначенияСвойств(РезультатВыбораПартии, Результат);
	ОбновитьИнформациюОПартии(ТекущиеДанные.Партия, Результат.ТипИзмеряемойВеличины);
	ОповеститьОВыборе(РезультатВыбораПартии);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьИнформациюОПартии(Партия, ТипИзмеряемойВеличины)
	
	УстановитьПривилегированныйРежим(Истина);
	Объект = Партия.ПолучитьОбъект();
	Объект.ТипИзмеряемойВеличиныСАТУРН = ТипИзмеряемойВеличины;
	Объект.ТипИзмеряемойВеличиныУстановленПользователем = Истина;
	Объект.Записать();

КонецПроцедуры

#КонецОбласти