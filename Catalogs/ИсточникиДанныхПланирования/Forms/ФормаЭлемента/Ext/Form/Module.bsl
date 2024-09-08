﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Создается новый элемент
	Если НЕ ЭтоАдресВременногоХранилища(АдресСКД) Тогда
		
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования.ИмяШаблонаСКД) Тогда
			
			// При копировании схема компоновки данных получается из копируемого объекта
			СхемаИсточника = Параметры.ЗначениеКопирования.СхемаКомпоновкиДанных.Получить();
			
		ИначеЕсли ЗначениеЗаполнено(Параметры.ЗначениеКопирования) И ЗначениеЗаполнено(Параметры.ЗначениеКопирования.ИмяШаблонаСКД) Тогда
			
			// При копировании схема компоновки данных получается из шаблона копируемого объекта.
			СхемаИсточника = Справочники.ИсточникиДанныхПланирования.СхемаКомпоновкиПоИмениШаблона(Параметры.ЗначениеКопирования.ИмяШаблонаСКД);
			
		Иначе
		
			
			// Создается новая схема компоновки данных
			СхемаИсточника = Новый СхемаКомпоновкиДанных;
			
		КонецЕсли;
		
		АдресСКД = ПоместитьВоВременноеХранилище(СхемаИсточника, УникальныйИдентификатор);
		
		РекомендуемаяВыборкаПоПериоду = РекомендуемаяВыборкаПоПериоду(СхемаИсточника);
		ПредупредитьОВыборкеДанных(РекомендуемаяВыборкаПоПериоду);
		
	КонецЕсли;
	
	// Создается новый элемент
	Если НЕ ЭтоАдресВременногоХранилища(АдресНастроекСКД) Тогда
		
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			
			// При копировании схема компоновки данных получается из копируемого объекта
			Попытка
				НастройкиКомпоновкиДанных = Параметры.ЗначениеКопирования.ХранилищеНастроекКомпоновкиДанных.Получить();
			Исключение
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В источнике заполнения данных ""%1"" имеются ошибки в настройках. Установлены настройки по умолчанию.'"), Параметры.ЗначениеКопирования.Ссылка));
			КонецПопытки;
		Иначе
			
			// Создается новая схема компоновки данных
			НастройкиКомпоновкиДанных = Неопределено;
			
		КонецЕсли;
		
		Если НастройкиКомпоновкиДанных <> Неопределено Тогда
			АдресНастроекСКД = ПоместитьВоВременноеХранилище(НастройкиКомпоновкиДанных, УникальныйИдентификатор);
		КонецЕсли; 
		
	КонецЕсли;
	
	ПолноеИмяИсточникаШаблонов = ОбщегоНазначения.ИмяТаблицыПоСсылке(Объект.Ссылка);
	МенеджерИсточникаШаблонов = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
		
	Для каждого МакетШаблона Из МенеджерИсточникаШаблонов.ШаблоныСхемыКомпоновкиДанных() Цикл
		НоваяСтрока = Шаблоны.Добавить();
		НоваяСтрока.Синоним = МакетШаблона.Синоним;
		НоваяСтрока.Имя = МакетШаблона.Имя;
		Если МакетШаблона.Свойство("ПолноеИмяИсточникаШаблонов") И ЗначениеЗаполнено(МакетШаблона.ПолноеИмяИсточникаШаблонов) Тогда
			НоваяСтрока.ПолноеИмяИсточникаШаблонов = МакетШаблона.ПолноеИмяИсточникаШаблонов;
		Иначе
			НоваяСтрока.ПолноеИмяИсточникаШаблонов = ПолноеИмяИсточникаШаблонов;
		КонецЕсли; 
		НоваяСтрока.ПолноеИмя = НоваяСтрока.ПолноеИмяИсточникаШаблонов + "." + НоваяСтрока.Имя;
		Элементы.ИмяШаблонаСКД.СписокВыбора.Добавить(НоваяСтрока.ПолноеИмя, МакетШаблона.Синоним);
		
	КонецЦикла;
	
	Если ПустаяСтрока(Объект.ИмяШаблонаСКД) Тогда
		
		Элементы.ИмяШаблонаСКД.СписокВыбора.Добавить("", НСтр("ru = 'Произвольная'"));
		
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ИмяШаблонаСКД) Тогда
		СхемаИсточника = Справочники.ИсточникиДанныхПланирования.СхемаКомпоновкиПоИмениШаблона(ТекущийОбъект.ИмяШаблонаСКД);
		Если СхемаИсточника = Неопределено Тогда
			СхемаИсточника = ТекущийОбъект.СхемаКомпоновкиДанных.Получить();
		КонецЕсли;
	Иначе
		СхемаИсточника = ТекущийОбъект.СхемаКомпоновкиДанных.Получить();
	КонецЕсли; 
	
	Попытка
		НастройкиКомпоновкиДанных = ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных.Получить();
	Исключение
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В источнике заполнения данных ""%1"" имеются ошибки в настройках. Установлены настройки по умолчанию.'"), ТекущийОбъект.Ссылка));
		ЭтаФорма.Модифицированность = Истина;
	КонецПопытки;
	
	// Загрузка схемы компоновки данных
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаИсточника, УникальныйИдентификатор);
	АдресНастроекСКД = "";
	Если НастройкиКомпоновкиДанных <> Неопределено Тогда
		АдресНастроекСКД = ПоместитьВоВременноеХранилище(НастройкиКомпоновкиДанных, УникальныйИдентификатор);
	КонецЕсли;
	
	РекомендуемаяВыборкаПоПериоду = РекомендуемаяВыборкаПоПериоду(СхемаИсточника);
	ПредупредитьОВыборкеДанных(РекомендуемаяВыборкаПоПериоду);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ИмяШаблонаСКД) Тогда
		СхемаКомпоновкиДанных = Справочники.ИсточникиДанныхПланирования.СхемаКомпоновкиПоИмениШаблона(ТекущийОбъект.ИмяШаблонаСКД);
	Иначе
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСКД);
		
		// Сохранение схемы компоновки данных
		ТекущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(СхемаКомпоновкиДанных);
	КонецЕсли; 
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Компоновка настроек источника данных планирования'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	Если ЭтоАдресВременногоХранилища(АдресНастроекСКД) Тогда
	
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекСКД);
		Если ОбщегоНазначения.ЗначениеВСтрокуXML(КомпоновщикНастроек.ПолучитьНастройки()) <> ОбщегоНазначения.ЗначениеВСтрокуXML(НастройкиКомпоновкиДанных) Тогда
			ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(НастройкиКомпоновкиДанных);
		Иначе
			ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		КонецЕсли;
	Иначе
	
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	
	КонецЕсли; 
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Редактировать(Команда)

	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройки источника данных планирования ""%ИмяИсточникаДанных%""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%ИмяИсточникаДанных%", Объект.Наименование);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных",                АдресСКД);
	ПараметрыФормы.Вставить("АдресНастроекКомпоновкиДанных",             АдресНастроекСКД);
	ПараметрыФормы.Вставить("ИсточникШаблонов",                          Объект.Ссылка);
	ПараметрыФормы.Вставить("Заголовок",                                 ЗаголовокФормыНастройкиСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("УникальныйИдентификатор",                   УникальныйИдентификатор);
	ПараметрыФормы.Вставить("ИмяШаблонаСКД",                             Объект.ИмяШаблонаСКД);
	ПараметрыФормы.Вставить("ВозвращатьИмяТекущегоШаблонаСКД",           Истина);
	ПараметрыФормы.Вставить("ВозвращатьПолноеИмяТекущегоШаблонаСКД",     Истина);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление",           Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок",                      Истина);
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	
	Оповещение = Новый ОписаниеОповещения("РедактироватьЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		ПараметрыФормы, 
		ЭтаФорма,,,,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура РедактироватьЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
	
		Объект.ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
		АдресНастроекСКД = Результат.АдресХранилищаНастройкиКомпоновщика;
		
		Объект.ВерсияШаблонаСКД = 0;
		
		РедактироватьЗавершениеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзМакета(ПолноеИмяИсточникаШаблонов, ИмяМакета)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СхемаКомпоновкиДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяИсточникаШаблонов).ПолучитьМакет(ИмяМакета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСКД);
	АдресНастроекСКД = "";
	
	РекомендуемаяВыборкаПоПериоду = РекомендуемаяВыборкаПоПериоду(СхемаКомпоновкиДанных);
	
	Если РекомендуемаяВыборкаПоПериоду.Найти(3) <> Неопределено Тогда
		Объект.ОграничениеВыборкиПоПериоду = 3;
	ИначеЕсли РекомендуемаяВыборкаПоПериоду.Найти(2) <> Неопределено Тогда
		Объект.ОграничениеВыборкиПоПериоду = 2;
	ИначеЕсли РекомендуемаяВыборкаПоПериоду.Найти(1) <> Неопределено Тогда
		Объект.ОграничениеВыборкиПоПериоду = 1;
	Иначе
		Объект.ОграничениеВыборкиПоПериоду = 0;
	КонецЕсли;
	
	ПредупредитьОВыборкеДанных(РекомендуемаяВыборкаПоПериоду);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОграничениеВыборкиПоПериодуПриИзменении(Элемент)
	
	ОграничениеВыборкиПоПериодуПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяШаблонаСКДПриИзменении(Элемент)
	
	Если Объект.ИмяШаблонаСКД = ИмяТекущегоШаблонаСКД Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("ПолноеИмя", Объект.ИмяШаблонаСКД));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Объект.ИмяШаблонаСКД = ИмяТекущегоШаблонаСКД;
		ТекстПредупреждения = НСтр("ru='Ошибка загрузки шаблона. Выберите другой шаблон.'");
  		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Текущие настройки будут потеряны. Продолжить?'");
	Оповещение = Новый ОписаниеОповещения("ИмяШаблонаСКДПриИзмененииЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИмяШаблонаСКДПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Объект.ИмяШаблонаСКД = ИмяТекущегоШаблонаСКД;
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("ПолноеИмя", Объект.ИмяШаблонаСКД));
	
	ЗагрузитьИзМакета(НайденныеСтроки[0].ПолноеИмяИсточникаШаблонов, НайденныеСтроки[0].Имя);
	
	Модифицированность = Истина;
	ИмяТекущегоШаблонаСКД = Объект.ИмяШаблонаСКД;
	
	Объект.ВерсияШаблонаСКД = 0;
	
	ПустойЭлемент = Элементы.ИмяШаблонаСКД.СписокВыбора.НайтиПоЗначению("");
	Если ПустойЭлемент <> Неопределено Тогда
		Элементы.ИмяШаблонаСКД.СписокВыбора.Удалить(ПустойЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РекомендуемаяВыборкаПоПериоду(СхемаКомпоновкиДанных)

	РекомендуемаяВыборкаПоПериоду = Новый Массив;
	
	Если СхемаКомпоновкиДанных.Параметры.Найти("СмещениеПериода") <> Неопределено 
		И СхемаКомпоновкиДанных.Параметры.Найти("ИспользуетсяСмещениеПериода") <> Неопределено 
		И СхемаКомпоновкиДанных.Параметры.Найти("НачалоПериодаСмещения") <> Неопределено 
		И СхемаКомпоновкиДанных.Параметры.Найти("КонецПериодаСмещения") <> Неопределено Тогда
	
		РекомендуемаяВыборкаПоПериоду.Добавить(3);
	КонецЕсли;
	
	Если СхемаКомпоновкиДанных.Параметры.Найти("НачалоПериода") <> Неопределено 
		И СхемаКомпоновкиДанных.Параметры.Найти("КонецПериода") <> Неопределено Тогда
	
		РекомендуемаяВыборкаПоПериоду.Добавить(2);
	КонецЕсли;
	
	Если СхемаКомпоновкиДанных.Параметры.Найти("Период") <> Неопределено 
		И РекомендуемаяВыборкаПоПериоду.Найти(2) = Неопределено
		И РекомендуемаяВыборкаПоПериоду.Найти(3) = Неопределено Тогда
	
		РекомендуемаяВыборкаПоПериоду.Добавить(1);
	
	КонецЕсли; 
	
	Если СхемаКомпоновкиДанных.Параметры.Найти("НачалоПериода") = Неопределено
		ИЛИ Не ЗначениеЗаполнено(СхемаКомпоновкиДанных.Параметры.Найти("НачалоПериода").Выражение)
		ИЛИ СхемаКомпоновкиДанных.Параметры.Найти("КонецПериода") = Неопределено 
		ИЛИ Не ЗначениеЗаполнено(СхемаКомпоновкиДанных.Параметры.Найти("КонецПериода").Выражение) Тогда
	
		РекомендуемаяВыборкаПоПериоду.Добавить(0);
	
	КонецЕсли;
	
	Возврат РекомендуемаяВыборкаПоПериоду;
	
КонецФункции

&НаСервере
Процедура ПредупредитьОВыборкеДанных(РекомендуемаяВыборкаПоПериоду = Неопределено)

	Если РекомендуемаяВыборкаПоПериоду = Неопределено Тогда
		СхемаИсточника = ПолучитьИзВременногоХранилища(АдресСКД);
		РекомендуемаяВыборкаПоПериоду = РекомендуемаяВыборкаПоПериоду(СхемаИсточника);
	КонецЕсли; 
	
	Если РекомендуемаяВыборкаПоПериоду.Найти(Объект.ОграничениеВыборкиПоПериоду) <> Неопределено Тогда
		Если Элементы.ДекорацияПредупреждениеОВыборкеДанных.Видимость Тогда
			Элементы.ДекорацияПредупреждениеОВыборкеДанных.Видимость = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Элементы.ОграничениеВыборкиПоПериоду.СписокВыбора;
	ПредставлениеТекущейВыборки = СписокВыбора.НайтиПоЗначению(Объект.ОграничениеВыборкиПоПериоду).Представление;
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Схема компоновки данных, возможно, не поддерживает выборку данных ""%1"".'"),
									ПредставлениеТекущейВыборки);
									
	РекомендуемыеВыборкиПоПериоду = "";
	Для каждого ЗначениеВыборкиПоПериоду Из РекомендуемаяВыборкаПоПериоду Цикл
		РекомендуемыеВыборкиПоПериоду = РекомендуемыеВыборкиПоПериоду 
										+ ?(РекомендуемыеВыборкиПоПериоду = "", "", ", ")
										+ СписокВыбора.НайтиПоЗначению(ЗначениеВыборкиПоПериоду).Представление;
	КонецЦикла;
	
	ТекстПредупреждения = ТекстПредупреждения
							+ Символы.ПС
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Рекомендуется использовать: %1.'"), 
									РекомендуемыеВыборкиПоПериоду);
							
	Элементы.ДекорацияПредупреждениеОВыборкеДанных.Заголовок = ТекстПредупреждения;

	Элементы.ДекорацияПредупреждениеОВыборкеДанных.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОграничениеВыборкиПоПериодуПриИзмененииНаСервере()

	ПредупредитьОВыборкеДанных();

КонецПроцедуры

&НаСервере
Процедура РедактироватьЗавершениеНаСервере()

	ПредупредитьОВыборкеДанных();

КонецПроцедуры

#КонецОбласти

#КонецОбласти
