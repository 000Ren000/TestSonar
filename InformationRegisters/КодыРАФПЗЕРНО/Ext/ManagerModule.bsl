﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КодыРАФППоВладельцу(ТаблицаОрганизацияКонтрагент) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив;
	
	Если ТаблицаОрганизацияКонтрагент.Количество() = 0 Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаОтбора.ОрганизацияКонтрагент КАК ОрганизацияКонтрагент,
		|	ТаблицаОтбора.Подразделение         КАК Подразделение,
		|	ТаблицаОтбора.КодРАФП               КАК КодРАФП
		|ПОМЕСТИТЬ ТаблицаОтбора
		|ИЗ
		|	&ТаблицаОтбора КАК ТаблицаОтбора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КодыРАФПЗЕРНО.КодРАФП               КАК КодРАФП,
		|	КодыРАФПЗЕРНО.ОрганизацияКонтрагент КАК ОрганизацияКонтрагент,
		|	КодыРАФПЗЕРНО.Подразделение         КАК Подразделение
		|ИЗ
		|	РегистрСведений.КодыРАФПЗЕРНО КАК КодыРАФПЗЕРНО
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОтбора КАК ТаблицаОтбора
		|		ПО ТаблицаОтбора.ОрганизацияКонтрагент = КодыРАФПЗЕРНО.ОрганизацияКонтрагент
		|		И ТаблицаОтбора.Подразделение = КодыРАФПЗЕРНО.Подразделение
		|";
	
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОрганизацияКонтрагент);
	
	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураДанныхИсточника = Новый Структура("ОрганизацияКонтрагент, Подразделение, КодРАФП");
		ЗаполнитьЗначенияСвойств(СтруктураДанныхИсточника, ВыборкаДетальныеЗаписи);
		ВозвращаемоеЗначение.Добавить(СтруктураДанныхИсточника);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПолучитьКодРАФППоДаннымСервиса(ИНН, КПП) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодРАФП",        Неопределено);
	Результат.Вставить("ОписаниеОшибки", "");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКонтрагентами") Тогда
	
		МодульРаботаСКонтрагентами = ОбщегоНазначения.ОбщийМодуль("РаботаСКонтрагентами");
		
		ДанныеЮрЛица = МодульРаботаСКонтрагентами.СведенияОЮридическомЛицеПоИНН(ИНН);
		
		Если ЗначениеЗаполнено(ДанныеЮрЛица.ОписаниеОшибки) Тогда
			ЗаполнитьЗначенияСвойств(Результат, ДанныеЮрЛица, "ОписаниеОшибки");
		Иначе
			Отбор = Новый Структура("КПП", КПП);
			СведенияОПредставительстве = ДанныеЮрЛица.РАФП.НайтиСтроки(Отбор);
			
			Если СведенияОПредставительстве.Количество() Тогда
				ДанныеАккредитации = СведенияОПредставительстве[0].Аккредитация;
				Если ДанныеАккредитации <> Неопределено
					И ТипЗнч(ДанныеАккредитации) = Тип("Структура")
					И ДанныеАккредитации.Свойство("НомерЗаписиОбАккредитации") Тогда
					Результат.КодРАФП = ДанныеАккредитации.НомерЗаписиОбАккредитации;
				КонецЕсли;
			Иначе
				Результат.ОписаниеОшибки = СтрШаблон(
					НСтр("ru = 'Не удалось получить код РАФП для ИНН: %1, КПП: %2.'"),
					ИНН,
					КПП);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Результат.ОписаниеОшибки = НСтр("ru = 'Интеграция с подсистемой ""Интернет-поддержка пользователей"" не подключена.'");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СохранитьДанныеРАФППоОрганизацииПодразделению(ОрганизацияКонтрагент, Подразделение, КодРАФП) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОрганизацияКонтрагент = ОрганизацияКонтрагент;
	МенеджерЗаписи.Подразделение         = Подразделение;
	МенеджерЗаписи.КодРАФП               = КодРАФП;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
