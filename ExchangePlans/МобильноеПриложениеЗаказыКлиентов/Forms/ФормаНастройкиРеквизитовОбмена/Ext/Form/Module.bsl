﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок =
		Нстр("ru = 'Настройка синхронизации реквизитов объектов для обмена с мобильным приложением ""1С:Заказы""'");
		
	ГлавныйУзел = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.ЭтотУзел();
	МобильноеПриложениеЗаказыКлиентовПереопределяемый.ЗаполнитьТаблицуСохраненныхРеквизитов(СохраненныеРеквизитыОбмена);
	ЗаполнитьДеревоОбъектовОбмена();
	ЗаполнитьТаблицуРеквизитов();
	
	Элементы.ДеревоОбъектовОбмена.ТекущаяСтрока = 1;
	ТекущийТипОбъекта = "Справочник.Номенклатура";
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоОбъектовОбмена

&НаКлиенте
Процедура ДеревоОбъектовОбменаПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоОбъектовОбмена.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийТипОбъекта = Элементы.ДеревоОбъектовОбмена.ТекущиеДанные.ОбъектОбмена;
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьЗавершение(, Новый Структура("Закрыть", Истина));
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ЗаписатьИЗакрытьЗавершение(, Новый Структура("Закрыть", Ложь));
КонецПроцедуры

&НаКлиенте
Процедура ТолькоВыбранные(Команда)
	
	Элементы.РеквизитыОбменаТолькоВыбранные.Пометка = НЕ Элементы.РеквизитыОбменаТолькоВыбранные.Пометка;
	ТолькоВыбранныеСервер(Элементы.РеквизитыОбменаТолькоВыбранные.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ТолькоДоступные(Команда)
	
	Элементы.РеквизитыОбменаТолькоДоступные.Пометка = НЕ Элементы.РеквизитыОбменаТолькоДоступные.Пометка;
	ТолькоДоступныеСервер(Элементы.РеквизитыОбменаТолькоДоступные.Пометка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет строку таблицы передаваемых реквизитов.
// Параметры:
//  РеквизитыОбъекта - ТаблицаЗначений - таблица реквизитов объекта;
//  Реквизит - ОбъектМетаданныхРеквизит, ОписаниеСтандартногоРеквизита, СтрокаТаблицыЗначений - ;
//  ПолноеИмяОбъектаМетаданных - Строка - ;
//  УчаствуетВсегда - Булево - .
//
&НаСервере
Процедура ДобавитьРеквизитВТаблицу(РеквизитыОбъекта, Реквизит, ПолноеИмяОбъектаМетаданных, УчаствуетВсегда = Ложь)
		
	СтрокаРеквизита = РеквизитыОбъекта.НайтиСтроки(Новый Структура("Реквизит, ИмяОбъекта, ТипЗначения",
		Реквизит.Имя, ПолноеИмяОбъектаМетаданных, Реквизит.Тип));
		
	Если СтрокаРеквизита.Количество() = 0 Тогда
		СтрокаРеквизит = РеквизитыОбъекта.Добавить();
	Иначе
		СтрокаРеквизит = СтрокаРеквизита[0];
	КонецЕсли;
	
	СтрокаРеквизит.Реквизит = Реквизит.Имя;
	Если ТипЗнч(СтрокаРеквизит.Реквизит) = Тип("Строка") Тогда
		СтрокаРеквизит.Представление = Реквизит.Представление();
		Недоступен = Ложь;
	Иначе
		СтрокаРеквизит.Представление = Реквизит.Представление;
		Недоступен = Реквизит.Недоступен;
	КонецЕсли;
	
	СтрокаРеквизит.УчаствуетВсегда = УчаствуетВсегда;
	СтрокаРеквизит.ИмяОбъекта = ПолноеИмяОбъектаМетаданных;
	СтрокаРеквизит.ТипЗначения = Реквизит.Тип;
	
	Участвует = Ложь;
	
	Если УчаствуетВсегда Тогда
		Участвует = Истина;
		Недоступен = Истина;
	КонецЕсли;
	
	Если ТипНедоступенДляОбмена(Реквизит.Тип) Тогда
		Участвует = УчаствуетВсегда;
		Недоступен = Истина;
	КонецЕсли;
	Если НЕ СтрНайти(Реквизит.Имя, "Удалить") = 0 Тогда
		Участвует = Ложь;
		Недоступен = Истина;
	КонецЕсли;
	
	Если НЕ УчаствуетВсегда Тогда
		Участвует = УчаствуетИзОписанияОбмена(Реквизит.Имя, ПолноеИмяОбъектаМетаданных);
		УчаствуетВсегда = Участвует;
		Если Не Недоступен Тогда
			Недоступен = Участвует;
		КонецЕсли;
		СтрокаРеквизит.УчаствуетВсегда = УчаствуетВсегда;
	КонецЕсли;
	
	Если НЕ УчаствуетВсегда И НЕ Недоступен Тогда
		СохраненнаяНастройка = УчаствуетИзСохраненныхНастроек(Реквизит, ПолноеИмяОбъектаМетаданных);
		Участвует = СохраненнаяНастройка.Участвует;
		СтрокаРеквизит.УникальныйИдентификаторСвойства = СохраненнаяНастройка.УникальныйИдентификаторСвойства;
	КонецЕсли;
	
	СтрокаРеквизит.Участвует = Участвует;
	СтрокаРеквизит.Недоступен = Недоступен;
КонецПроцедуры

&НаСервере
Функция ДополнительныеРеквизитыПоОбъектуМетаданных(ПолноеИмяОбъектаМетаданных)
	
	Наборы = Новый СписокЗначений;
	Если ПолноеИмяОбъектаМетаданных = "Справочник.Организации" Тогда
		Наборы.Добавить(УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Организации"));
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Справочник.Номенклатура" Тогда
		Наборы = НаборыСвойствДляНоменклатуры();
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Справочник.Партнеры" Тогда
		Наборы = УправлениеСвойствамиПереопределяемый.ПолучитьНаборыСвойствДляПартнеров(Истина, Ложь, Ложь, Ложь);
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Документ.ЗаказКлиента" Тогда
		Наборы.Добавить(УправлениеСвойствами.НаборСвойствПоИмени("Документ_ЗаказКлиента"));
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Документ.ЗаявкаНаВозвратТоваровОтКлиента" Тогда
		Наборы.Добавить(УправлениеСвойствами.НаборСвойствПоИмени("Документ_ЗаявкаНаВозвратТоваровОтКлиента"));
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	НаборыДополнительныхРеквизитов.Свойство КАК Имя,
	|	НаборыДополнительныхРеквизитов.Свойство.ТипЗначения КАК Тип,
	|	НаборыДополнительныхРеквизитов.Свойство.Представление КАК Представление,
	|	ВЫБОР
	|		КОГДА НЕ НаборыДополнительныхРеквизитов.Свойство.Доступен
	|				ИЛИ НЕ НаборыДополнительныхРеквизитов.Свойство.Виден
	|				ИЛИ НаборыДополнительныхРеквизитов.Свойство.ПометкаУдаления
	|				ИЛИ НаборыДополнительныхРеквизитов.ПометкаУдаления
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Недоступен
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК НаборыДополнительныхРеквизитов
	|ГДЕ
	|	НаборыДополнительныхРеквизитов.Ссылка В(&Наборы)");
	
	Запрос.УстановитьПараметр("Наборы", Наборы);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Отказ = Ложь;
	ЗаписатьНастройки(Отказ);
	Если Не Отказ Тогда
		Модифицированность = Ложь;
		Если ДополнительныеПараметры = Неопределено Тогда
			Закрыть();
		Иначе
			Если ДополнительныеПараметры.Свойство("Закрыть") И ДополнительныеПараметры.Закрыть Тогда
				Закрыть();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки(Отказ)
	
	НовыеНастройки = РеквизитыОбмена.Выгрузить(Новый Структура("УчаствуетВсегда, Недоступен", Ложь, Ложь),
		"Реквизит, Участвует, ИмяОбъекта, ТипЗначения, УникальныйИдентификаторСвойства, Представление");
	Для Каждого Строка Из НовыеНастройки Цикл
		Если НЕ ЗначениеЗаполнено(Строка.УникальныйИдентификаторСвойства) Тогда
			Если ТипЗнч(Строка.Реквизит) = Тип("Строка") Тогда
				Строка.УникальныйИдентификаторСвойства = Новый УникальныйИдентификатор;
			Иначе
				Строка.УникальныйИдентификаторСвойства = Строка.Реквизит.УникальныйИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		ГлавныйУзелОбъект = ГлавныйУзел.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ГлавныйУзелОбъект.Ссылка);
		ГлавныйУзелОбъект.НастройкиРеквизитовОбмена = Новый ХранилищеЗначения(НовыеНастройки, Новый СжатиеДанных(9));
		ГлавныйУзелОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Запись настроек'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки(),,,, Отказ);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоОбъектовОбмена()
	
	КоллекцияОбъектовОбмена = ДеревоОбъектовОбмена.ПолучитьЭлементы();
	
	СтрокаСправочники = КоллекцияОбъектовОбмена.Добавить();
	СтрокаСправочники.ОбъектОбмена = "Справочники";
	СтрокаСправочники.Представление = НСтр("ru = 'Справочники'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	КоллекцияОбъектовСправочников = СтрокаСправочники.ПолучитьЭлементы();
	
	СтрокаОбъекты = КоллекцияОбъектовСправочников.Добавить();
	СтрокаОбъекты.ОбъектОбмена = "Справочник.Номенклатура";
	СтрокаОбъекты.Представление = НСтр("ru = 'Номенклатура'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	СтрокаОбъекты = КоллекцияОбъектовСправочников.Добавить();
	СтрокаОбъекты.ОбъектОбмена = "Справочник.Партнеры";
	СтрокаОбъекты.Представление = НСтр("ru = 'Партнеры'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	СтрокаОбъекты = КоллекцияОбъектовСправочников.Добавить();
	СтрокаОбъекты.ОбъектОбмена = "Справочник.Организации";
	СтрокаОбъекты.Представление = НСтр("ru = 'Организации'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	СтрокаДокументы = КоллекцияОбъектовОбмена.Добавить();
	СтрокаДокументы.ОбъектОбмена = "Документы";
	СтрокаДокументы.Представление = НСтр("ru = 'Документы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	КоллекцияОбъектовДокументы = СтрокаДокументы.ПолучитьЭлементы();
	
	СтрокаОбъекты = КоллекцияОбъектовДокументы.Добавить();
	СтрокаОбъекты.ОбъектОбмена = "Документ.ЗаказКлиента";
	СтрокаОбъекты.Представление = НСтр("ru = 'Заказ клиента'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	СтрокаОбъекты = КоллекцияОбъектовДокументы.Добавить();
	СтрокаОбъекты.ОбъектОбмена = "Документ.ЗаявкаНаВозвратТоваровОтКлиента";
	СтрокаОбъекты.Представление = НСтр("ru = 'Заявка на возврат товаров от клиента'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРеквизитов()
	
	КоллекцияСтрокДерева = ДеревоОбъектовОбмена.ПолучитьЭлементы();
	
	Для Каждого СтрокаДерева Из КоллекцияСтрокДерева Цикл
		КоллекцияСтрокМетаданных = СтрокаДерева.ПолучитьЭлементы();
		Для Каждого Строка Из КоллекцияСтрокМетаданных Цикл
			ЗаполнитьТаблицуРеквизитовПоОбъектуМетаданных(Строка.ОбъектОбмена);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРеквизитовПоОбъектуМетаданных(ПолноеИмяОбъектаМетаданных)
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбмена, Реквизит, ПолноеИмяОбъектаМетаданных, Истина);
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбмена, Реквизит, ПолноеИмяОбъектаМетаданных);
	КонецЦикла;
	
	ДополнительныеРеквизиты = ДополнительныеРеквизитыПоОбъектуМетаданных(ПолноеИмяОбъектаМетаданных);
	
	Для Каждого Реквизит Из ДополнительныеРеквизиты Цикл
		ДобавитьРеквизитВТаблицу(РеквизитыОбмена, Реквизит, ПолноеИмяОбъектаМетаданных);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция НаборыСвойствДляНоменклатуры()
	
	Наборы = Новый СписокЗначений;
	
	НаборСвойств = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Номенклатура_Общие");
	Наборы.Добавить(НаборСвойств);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВидыНоменклатуры.НаборСвойств
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	НЕ ВидыНоменклатуры.ПометкаУдаления
	|	И НЕ ВидыНоменклатуры.НаборСвойств.ПометкаУдаления
	|	И НЕ ВидыНоменклатуры.НаборСвойств = ЗНАЧЕНИЕ(Справочник.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Наборы;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Наборы.Добавить(Выборка.НаборСвойств);
	КонецЦикла;
	
	Возврат Наборы;
КонецФункции

&НаСервере
Функция ТипНедоступенДляОбмена(ТипЗначенияРеквизита)
	
	// Выгружаем реквизиты только не составного типа, содержащие простые типы и
	// типы "СправочникСсылка.ЗначенияСвойствОбъектов" и "СправочникСсылка.ЗначенияСвойствОбъектовИерархия".
	Если ТипЗначенияРеквизита.Типы().Количество() = 1
		И (ТипЗначенияРеквизита.СодержитТип(Тип("Булево"))
			ИЛИ ТипЗначенияРеквизита.СодержитТип(Тип("Дата"))
			ИЛИ ТипЗначенияРеквизита.СодержитТип(Тип("Строка"))
			ИЛИ ТипЗначенияРеквизита.СодержитТип(Тип("Число"))
			ИЛИ ТипЗначенияРеквизита.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
			ИЛИ ТипЗначенияРеквизита.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"))) Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ТолькоВыбранныеСервер(Пометка)
	
	ЭлементУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Получить(3);
	ЭлементУсловноеОформление.Использование = Пометка;
КонецПроцедуры

&НаСервере
Процедура ТолькоДоступныеСервер(Пометка)
	
	ЭлементУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Получить(4);
	ЭлементУсловноеОформление.Использование = Пометка;
КонецПроцедуры

&НаСервере
Функция УчаствуетИзСохраненныхНастроек(Реквизит, ПолноеИмяОбъектаМетаданных)
	
	СохраненнаяНастройка = Новый Структура("Участвует, УникальныйИдентификаторСвойства", Ложь, "");
	СтрокаРеквизита = СохраненныеРеквизитыОбмена.НайтиСтроки(Новый Структура("Реквизит, ИмяОбъекта, ТипЗначения",
		Реквизит.Имя, ПолноеИмяОбъектаМетаданных, Реквизит.Тип));
		
	Если НЕ СтрокаРеквизита.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(СохраненнаяНастройка, СтрокаРеквизита[0]);
		Если НЕ ЗначениеЗаполнено(СохраненнаяНастройка.УникальныйИдентификаторСвойства) Тогда
			Если ТипЗнч(Реквизит.Имя) = Тип("Строка") Тогда
				СохраненнаяНастройка.УникальныйИдентификаторСвойства = Новый УникальныйИдентификатор;
			Иначе
				СохраненнаяНастройка.УникальныйИдентификаторСвойства = Реквизит.Имя.УникальныйИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СохраненнаяНастройка;
КонецФункции

&НаСервере
Функция УчаствуетИзОписанияОбмена(ИмяРеквизита, ПолноеИмяОбъектаМетаданных)
	
	МассивИспользованныхРеквизитов = Новый Массив;
	Если ПолноеИмяОбъектаМетаданных = "Справочник.Номенклатура" Тогда
		МассивИспользованныхРеквизитов.Добавить("СтавкаНДС");
		МассивИспользованныхРеквизитов.Добавить("Артикул");
		МассивИспользованныхРеквизитов.Добавить("ВесЕдиницаИзмерения");
		МассивИспользованныхРеквизитов.Добавить("ВесЗнаменатель");
		МассивИспользованныхРеквизитов.Добавить("ВесИспользовать");
		МассивИспользованныхРеквизитов.Добавить("ВесМожноУказыватьВДокументах");
		МассивИспользованныхРеквизитов.Добавить("ВесЧислитель");
		МассивИспользованныхРеквизитов.Добавить("ВидНоменклатуры");
		МассивИспользованныхРеквизитов.Добавить("ЕдиницаИзмерения");
		МассивИспользованныхРеквизитов.Добавить("НаименованиеПолное");
		МассивИспользованныхРеквизитов.Добавить("Описание");
		МассивИспользованныхРеквизитов.Добавить("ФайлКартинки");
		МассивИспользованныхРеквизитов.Добавить("ЦеноваяГруппа");
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Справочник.Партнеры" Тогда
		МассивИспользованныхРеквизитов.Добавить("Клиент");
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Справочник.Организации" Тогда
		МассивИспользованныхРеквизитов.Добавить("Префикс");
		МассивИспользованныхРеквизитов.Добавить("ИНН");
		МассивИспользованныхРеквизитов.Добавить("КПП");
		МассивИспользованныхРеквизитов.Добавить("НаименованиеПолное");
		МассивИспользованныхРеквизитов.Добавить("ЮрФизЛицо");
		МассивИспользованныхРеквизитов.Добавить("СвидетельствоСерияНомер");
		МассивИспользованныхРеквизитов.Добавить("СвидетельствоДатаВыдачи");
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Документ.ЗаказКлиента" Тогда
		МассивИспользованныхРеквизитов.Добавить("СуммаДокумента");
		МассивИспользованныхРеквизитов.Добавить("ЦенаВключаетНДС");
		МассивИспользованныхРеквизитов.Добавить("НеОтгружатьЧастями");
		МассивИспользованныхРеквизитов.Добавить("МаксимальныйКодСтроки");
		МассивИспользованныхРеквизитов.Добавить("Согласован");
		МассивИспользованныхРеквизитов.Добавить("СуммаАвансаДоОбеспечения");
		МассивИспользованныхРеквизитов.Добавить("СуммаПредоплатыДоОтгрузки");
		МассивИспользованныхРеквизитов.Добавить("ДатаОтгрузки");
		МассивИспользованныхРеквизитов.Добавить("АдресДоставки");
		МассивИспользованныхРеквизитов.Добавить("СкидкиРассчитаны");
		МассивИспользованныхРеквизитов.Добавить("Комментарий");
		МассивИспользованныхРеквизитов.Добавить("ВремяДоставкиС");
		МассивИспользованныхРеквизитов.Добавить("ВремяДоставкиПо");
		МассивИспользованныхРеквизитов.Добавить("АдресДоставкиЗначенияПолей");
		МассивИспользованныхРеквизитов.Добавить("ДополнительнаяИнформацияПоДоставке");
	ИначеЕсли ПолноеИмяОбъектаМетаданных = "Документ.ЗаявкаНаВозвратТоваровОтКлиента" Тогда
		МассивИспользованныхРеквизитов.Добавить("СуммаДокумента");
		МассивИспользованныхРеквизитов.Добавить("ЖелаемаяДатаПоступления");
		МассивИспользованныхРеквизитов.Добавить("ЦенаВключаетНДС");
		МассивИспользованныхРеквизитов.Добавить("ДатаПоступления");
		МассивИспользованныхРеквизитов.Добавить("АдресДоставки");
		МассивИспользованныхРеквизитов.Добавить("Комментарий");
		МассивИспользованныхРеквизитов.Добавить("ВремяДоставкиС");
		МассивИспользованныхРеквизитов.Добавить("ВремяДоставкиПо");
		МассивИспользованныхРеквизитов.Добавить("АдресДоставкиЗначенияПолей");
		МассивИспользованныхРеквизитов.Добавить("ДополнительнаяИнформацияПоДоставке");
	КонецЕсли;
	
	НайденныйРеквизит = МассивИспользованныхРеквизитов.Найти(ИмяРеквизита);
	
	Возврат НЕ НайденныйРеквизит = Неопределено;
КонецФункции

#КонецОбласти
