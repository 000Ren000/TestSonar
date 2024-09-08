﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФормуПоПереданнымПараметрам();
	Элементы.Изменения.ОтборСтрок = Новый ФиксированнаяСтруктура("СкрытьСтроку", Ложь);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИзменения

&НаКлиенте
Процедура ИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Изменения.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ИзмененияОрганизацияСАТУРН
		И ЗначениеЗаполнено(ТекущиеДанные.ОрганизацияСАТУРН) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ОрганизацияСАТУРН);
		
	ИначеЕсли Поле = Элементы.ИзмененияДокументОснование
		И ЗначениеЗаполнено(ТекущиеДанные.ДокументОснование) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ДокументОснование);
	
	ИначеЕсли Поле = Элементы.ИзмененияОбъект
		И ТекущиеДанные.Объект.Количество() Тогда
		
		СтандартнаяОбработка = Ложь;
		Если ТекущиеДанные.Объект.Количество() = 1 Тогда
			ПоказатьЗначение(Неопределено, ТекущиеДанные.Объект[0].Значение);
		Иначе
			ВыбораИзСпискаЗначенийЗавершение = Новый ОписаниеОповещения("ВыбораИзСпискаЗначенийЗавершение", ЭтотОбъект);
			ПоказатьВыборИзСписка(ВыбораИзСпискаЗначенийЗавершение, ТекущиеДанные.Объект, Элемент,);
		КонецЕсли;
		
	ИначеЕсли Поле = Элементы.ИзмененияПротоколОбмена Тогда
		
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущиеДанные.ПротоколОбмена) Тогда
		
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Источник",  ТекущиеДанные.ПротоколОбмена);
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Протокол обмена'"));
			
			ОткрытьФорму(
				"ОбщаяФорма.ЛогОбменаСАТУРН",
				ПараметрыФормы,
				ЭтотОбъект,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		ИначеЕсли ТекущиеДанные.ЕстьВОчередиОбмена Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Источник",  ТекущиеДанные.ИдентификаторСообщения);
			ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Протокол обмена'"));
			
			ОткрытьФорму(
				"ОбщаяФорма.ЛогОбменаСАТУРН",
				ПараметрыФормы,
				ЭтотОбъект,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоПереданнымПараметрам()
	
	ВсеИзмененныеОбъекты = Новый Соответствие();
	
	ЕстьОснование = Ложь;
	
	Для Каждого ЭлементДанных Из Параметры.Изменения Цикл
		
		Если ТипЗнч(ЭлементДанных.Объект) = Тип("Соответствие") Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьСтроку = Истина;
		Если ЗначениеЗаполнено(ЭлементДанных.ИдентификаторСообщения) Тогда
			СтруктураПоиска = Новый Структура();
			СтруктураПоиска.Вставить("ИдентификаторСообщения", ЭлементДанных.ИдентификаторСообщения);
			СтрокиПоИдентификатору = Изменения.НайтиСтроки(СтруктураПоиска);
			Если СтрокиПоИдентификатору.Количество() Тогда
				СтрокаДанных = СтрокиПоИдентификатору[0];
				Если Не ЗначениеЗаполнено(СтрокаДанных.ПротоколОбмена)
					И ЗначениеЗаполнено(ЭлементДанных.ПротоколОбмена) Тогда
					СтрокаДанных.ПротоколОбмена = ЭлементДанных.ПротоколОбмена;
					ДобавитьСтроку = Ложь;
				ИначеЕсли СтрокаДанных.ПротоколОбмена = ЭлементДанных.ПротоколОбмена
					Или ЗначениеЗаполнено(СтрокаДанных.ПротоколОбмена)
					И Не ЗначениеЗаполнено(ЭлементДанных.ПротоколОбмена)Тогда
					ДобавитьСтроку = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ДобавитьСтроку Тогда
			СтрокаДанных = Изменения.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанных, ЭлементДанных,, "Объект");
			СтрокаДанных.ОписаниеОперации = ИнтеграцияСАТУРНСлужебный.ОписаниеОперацииПередачиДанных(
				СтрокаДанных.Операция,,,
				ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПредставлениеНомераСтраницы(СтрокаДанных.НомерСтраницы));
		ИначеЕсли ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			СтрокаДанных.ТекстОшибки = ЭлементДанных.ТекстОшибки;
		КонецЕсли;
		
		ИзмененныеОбъекыПрисутствуютВДругихСтроках = Истина;
		Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
			Для Каждого Объект Из ЭлементДанных.Объект Цикл
				Если Не ЗначениеЗаполнено(Объект)
					Или СтрокаДанных.Объект.НайтиПоЗначению(Объект) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				СтрокаДанных.Объект.Добавить(Объект);
				Если ВсеИзмененныеОбъекты[Объект] = Неопределено Тогда
					ИзмененныеОбъекыПрисутствуютВДругихСтроках = Ложь;
				КонецЕсли;
				ВсеИзмененныеОбъекты.Вставить(Объект, ЭлементДанных);
			КонецЦикла;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаДанных.ДокументОснование) Тогда
			ЕстьОснование = Истина;
		КонецЕсли;
		
		Если Перечисления.ВидыОперацийСАТУРН.ЭтоАбстрактнаяОперация(ЭлементДанных.Операция)
			И Не Перечисления.ВидыОперацийСАТУРН.ОперацияЯвляетсяОснованием(ЭлементДанных.Операция)
			И ИзмененныеОбъекыПрисутствуютВДругихСтроках Тогда
			СтрокаДанных.СкрытьСтроку = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаДанных Из Изменения Цикл
		
		Если Перечисления.ВидыОперацийСАТУРН.ОперацияЯвляетсяОснованием(СтрокаДанных.Операция) Тогда
			СтруктураПоиска = Новый Структура("ИдентификаторСообщенияОснования", СтрокаДанных.ИдентификаторСообщения);
			ПодчиненныеСтроки = Изменения.НайтиСтроки(СтруктураПоиска);
			Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
				ПодчиненнаяСтрока.СкрытьСтроку = Истина;
				Для Каждого ЭлементСпискаЗначений Из ПодчиненнаяСтрока.Объект Цикл
					Если СтрокаДанных.Объект.НайтиПоЗначению(ЭлементСпискаЗначений.Значение) = Неопределено Тогда
						СтрокаДанных.Объект.Добавить(ЭлементСпискаЗначений.Значение);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		Если СтрокаДанных.Объект.Количество() = 1 Тогда
			СтрокаДанных.ПредставлениеОбъекта = Строка(СтрокаДанных.Объект[0].Значение);
		ИначеЕсли СтрокаДанных.Объект.Количество() Тогда
			СтрокаДанных.ПредставлениеОбъекта = СтрШаблон(
				НСтр("ru = '%1 (+ еще %2)'"),
				Строка(СтрокаДанных.Объект[0].Значение),
				СтрокаДанных.Объект.Количество() - 1);
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьПризнакНаличияВОчередиСообщений();
	
	Элементы.ИзмененияДокументОснование.Видимость = ЕстьОснование;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияОбъект.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Изменения.ПредставлениеОбъекта");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Изменения.ПредставлениеОбъекта"));
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияПротоколОбмена.Имя);
	
	ГруппаИли = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияПротоколОбмена.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Изменения.ТекстОшибки");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      Новый ПолеКомпоновкиДанных("Изменения.ТекстОшибки"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияПротоколОбмена.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияПротоколОбмена.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Изменения.ТекстОшибки");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<выполнено успешно>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияИндексКартинкиПротоколаОбмена.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияПротоколОбмена.Имя);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Изменения.ТекстОшибки");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Изменения.ЕстьВОчередиОбмена");
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<отсутствует>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИзмененияОперация.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Изменения.ОписаниеОперации");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Изменения.ОписаниеОперации"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбораИзСпискаЗначенийЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ВыбранноеЗначение.Значение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПризнакНаличияВОчередиСообщений()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОчередьСообщенийСАТУРН.Сообщение
		|ИЗ
		|	РегистрСведений.ОчередьСообщенийСАТУРН КАК ОчередьСообщенийСАТУРН
		|ГДЕ
		|	ОчередьСообщенийСАТУРН.Сообщение В (&Сообщение)";
	
	Сообщения = Изменения.Выгрузить().ВыгрузитьКолонку("ИдентификаторСообщения");
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(Сообщения, Неопределено);
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(Сообщения, "");
	Запрос.УстановитьПараметр("Сообщение", Сообщения);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Отбор = Новый Структура("ИдентификаторСообщения");
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Отбор.ИдентификаторСообщения = ВыборкаДетальныеЗаписи.Сообщение;
		ПоискСтрок = Изменения.НайтиСтроки(Отбор);
		Для Каждого СтрокаТаблицы Из ПоискСтрок Цикл
			СтрокаТаблицы.ЕстьВОчередиОбмена = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти