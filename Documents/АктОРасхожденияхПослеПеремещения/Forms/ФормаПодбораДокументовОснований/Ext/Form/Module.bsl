﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,
	                        "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, ТолькоПросмотр");
	
	Период = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АктОРасхожденияхПослеПеремещения.ФормаПодбораДокументовОснований", 
	                                                          "ПериодПодбораОснованийАктОРасхожденияПослеПеремещения");
	Если Период.ДатаОкончания = Дата(1, 1, 1) И Период.ДатаОкончания = Дата(1, 1, 1) Тогда
		Период.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;
	
	ВариантПереноса = "Вариант1";
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Элементы.ИнформационнаяНадписьОтборы.Высота = 1;
	КонецЕсли;
	
	ЗаполнитьТаблицуДокументовОснований();
	СформироватьИнформационнуюНадписьОтборы();
	СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АктОРасхожденияхПослеПеремещения.ФормаПодбораДокументовОснований",
	                                                 "ПериодПодбораОснованийАктОРасхожденияПослеПеремещения",
	                                                 Период);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки <> Неопределено Тогда
		Настройки.Удалить("Период");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		ЕстьИзменения = Ложь;
		
		ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
		Если ВыбранныеСтроки.Количество() <> ДокументыОснования.Количество() Тогда
			ЕстьИзменения = Истина;
		ИначеЕсли ВыбранныеСтроки.Количество() = 0 ИЛИ ДокументыОснования.Количество() = 0 Тогда
			
			ЕстьИзменения = Истина;
			
		Иначе
			Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
				Если ДокументыОснования.НайтиПоЗначению(ВыбраннаяСтрока.Ссылка) = Неопределено Тогда
					ЕстьИзменения = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекстВопроса = НСтр("ru = 'Состав документов-оснований был изменен. Принять изменения?'");
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросОПринятииИзмененийПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли ПеренестиВДокумент  Тогда
		
		Если Не ОчисткаПодтверждена И ТабличнаяЧастьНеПустая Тогда
			Если ВариантПереноса = "Вариант1" Тогда
				ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена и перезаполнена. Продолжить?'");
			Иначе
				ТекстВопроса = НСтр("ru = 'Табличная часть документа будет перезаполнена. Продолжить?'");
			КонецЕсли;
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросООчисткеТабличнойЧастиПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Отказ = Истина;
		Иначе
			
			ПеренестиВДокумент();
			Отказ = Истина;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТабличнойЧастиРеализации

&НаКлиенте
Процедура РеализацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(, Основания.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацииВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Основания.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗнакОперации = ?(ТекущиеДанные.Выбран,1,-1);
	КоличествоДокументов = КоличествоДокументов + 1*ЗнакОперации;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВсе(Команда)
	
	УстановитьФлагиВыбрано(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	УстановитьФлагиВыбрано(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуДокументовОснований()
	
	ТаблицаОснованийДокумента = Новый ТаблицаЗначений();
	ТаблицаОснованийДокумента.Колонки.Добавить("ДокументОснование", 
		Новый ОписаниеТипов("ДокументСсылка.ПеремещениеТоваров, ДокументСсылка.РеализацияТоваровУслуг, ДокументСсылка.ВозвратТоваровПоставщику"));
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОснованияДокумента.ДокументОснование
	|ПОМЕСТИТЬ ВыбранныеДокументы
	|ИЗ
	|	&ОснованияДокумента КАК ОснованияДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВыбранныеДокументы.ДокументОснование ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ПеремещениеТоваров.Номер,
	|	ПеремещениеТоваров.Дата,
	|	ПеремещениеТоваров.Ссылка
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
	|		ПО ПеремещениеТоваров.Ссылка = ВыбранныеДокументы.ДокументОснование
	|ГДЕ
	|	ПеремещениеТоваров.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И ПеремещениеТоваров.Организация = &Организация
	|	И ПеремещениеТоваров.ОрганизацияПолучатель = &ОрганизацияПолучатель
	|	И ПеремещениеТоваров.СкладОтправитель = &СкладОтправитель
	|	И ПеремещениеТоваров.СкладПолучатель = &СкладПолучатель
	|	И ПеремещениеТоваров.Проведен
	|	И ВЫБОР
	|			КОГДА &ДатаНачала = &ПустаяДата
	|					И &ДатаОкончания = &ПустаяДата
	|				ТОГДА ИСТИНА
	|			КОГДА &ДатаНачала = &ПустаяДата
	|				ТОГДА ПеремещениеТоваров.Дата <= &ДатаОкончания
	|			КОГДА &ДатаОкончания = &ПустаяДата
	|				ТОГДА ПеремещениеТоваров.Дата >= &ДатаНачала
	|			ИНАЧЕ ПеремещениеТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользуютсяСерииНаСкладеПолучателе
	|				ТОГДА ПеремещениеТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПеремещенийТоваров.Принято)
	|			ИНАЧЕ ПеремещениеТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПеремещенийТоваров.Отгружено)
	|					ИЛИ ПеремещениеТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПеремещенийТоваров.Принято)
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПеремещениеТоваров.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("СкладОтправитель", СкладОтправитель);
	Запрос.УстановитьПараметр("СкладПолучатель", СкладПолучатель);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
	
	ИспользуютсяСерииНаСкладеПолучателе = СкладыСервер.ИспользованиеСерийНаСкладе(СкладПолучатель, Ложь);
	Запрос.УстановитьПараметр("ИспользуютсяСерииНаСкладеПолучателе", ИспользуютсяСерииНаСкладеПолучателе.ИспользоватьСерииНоменклатуры);
	
	Для Каждого ЭлементСписка Из ДокументыОснования Цикл
		НоваяСтрока = ТаблицаОснованийДокумента.Добавить();
		НоваяСтрока.ДокументОснование = ЭлементСписка.Значение;
	КонецЦикла;
	Запрос.УстановитьПараметр("ОснованияДокумента", ТаблицаОснованийДокумента);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Основания.Очистить();
	Иначе
		Основания.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПринятииИзмененийПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросООчисткеТабличнойЧастиПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПеренестиВДокумент();
		
	Иначе
		
		ПеренестиВДокумент = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент()
	
	МассивВыбранныхДокументов = Новый Массив;
	ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		МассивВыбранныхДокументов.Добавить(ВыбраннаяСтрока.Ссылка);
	КонецЦикла;
	
	ОчисткаПодтверждена = Истина;
	ЗакрытьФорму = Истина;
	ОповеститьОВыборе(МассивВыбранныхДокументов);
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьФлагиВыбрано(Включать)

	Для Каждого СтрокаТаблицы Из Основания Цикл
		СтрокаТаблицы.Выбран = Включать;
	КонецЦикла;
	
	Если Включать Тогда
		СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма)
	Иначе
		КоличествоДокументов = 0;
		ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьИнформационнуюНадписьОтборы()

	ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Организация%, %ОрганизацияПолучатель%, %СкладОтправитель%, %СкладПолучатель%, %ХозяйственнаяОперация%.'");

	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Организация%", Организация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ОрганизацияПолучатель%", ОрганизацияПолучатель);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%СкладОтправитель%", СкладОтправитель);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%СкладПолучатель%", СкладПолучатель);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ХозяйственнаяОперация%", ХозяйственнаяОперация);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьИнформационнуюНадписьКоличествоДокументов(Форма)

	Форма.КоличествоДокументов = 0;
	
	Для Каждого СтрокаТаблицы Из Форма.Основания Цикл
		Если СтрокаТаблицы.Выбран Тогда
			Форма.КоличествоДокументов = Форма.КоличествоДокументов + 1;
		КонецЕсли;
	КонецЦикла;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформационнуюНадписьКоличествоДокументов(Форма)

	Если Форма.КоличествоДокументов <> 0 Тогда
		ТекстНадписи = НСтр("ru = 'Подобрано документов - %КоличествоДокументов%.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%КоличествоДокументов%", Форма.КоличествоДокументов);
	Иначе
		ТекстНадписи = НСтр("ru = 'Подобрано 0 документов.'");
	КонецЕсли;
	
	Форма.ИнформационнаяНадписьКоличествоДокументов = ТекстНадписи;

КонецПроцедуры

#КонецОбласти

