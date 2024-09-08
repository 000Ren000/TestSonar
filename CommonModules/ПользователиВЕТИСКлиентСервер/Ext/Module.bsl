﻿
#Область СлужебныйПрограммныйИнтерфейс

// Формирует структуру для записи данных пользователя ВЕТИС
//
Функция СтруктураДанныхПользователяВЕТИС() Экспорт
	
	ДанныеПользователя = СтруктураРазграниченияДоступаПользователя();
	ДанныеПользователя.Вставить("УчетнаяЗапись",       "");
	ДанныеПользователя.Вставить("ИдентификаторВерсии", "");
	ДанныеПользователя.Вставить("Фамилия",             "");
	ДанныеПользователя.Вставить("Имя",                 "");
	ДанныеПользователя.Вставить("Отчество",            "");
	ДанныеПользователя.Вставить("ДатаРождения",        "");
	ДанныеПользователя.Вставить("ДокументТип",         ПредопределенноеЗначение("Перечисление.ТипыДокументовВЕТИС.ПустаяСсылка"));
	ДанныеПользователя.Вставить("ДокументСерия",       "");
	ДанныеПользователя.Вставить("ДокументНомер",       "");
	ДанныеПользователя.Вставить("СтранаИдентификатор", "");
	ДанныеПользователя.Вставить("СНИЛС",               "");
	ДанныеПользователя.Вставить("ЛичныйТелефон",       "");
	ДанныеПользователя.Вставить("ЛичныйEmail",         "");
	ДанныеПользователя.Вставить("РабочийТелефон",      "");
	ДанныеПользователя.Вставить("РабочийEmail",        "");
	ДанныеПользователя.Вставить("Должность",           "");
	ДанныеПользователя.Вставить("Пользователь",        ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	
	Возврат ДанныеПользователя;
	
КонецФункции

// Формирует структуру для записи пользователя ВЕТИС и его ограничений по правам и зоне ответственности
//
// Возвращаемое значение:
// Структура - Структура со свойствами:
//  * ПользовательВЕТИС - СправочникСсылка.ПользователиВЕТИС - пользователь ВЕТИС.
//  * ПраваДоступа      - Массив - массив значений перечисления "ПраваДоступаВЕТИС".
//  * Предприятия       - Массив - массив значений справочника "ПредприятияВЕТИС".
//  * Адреса            - Массив - массив структур с адресами зон ответственности.
//
Функция СтруктураРазграниченияДоступаПользователя() Экспорт
	
	СтруктураОграничений = Новый Структура();
	СтруктураОграничений.Вставить("ПользовательВЕТИС", ПредопределенноеЗначение("Справочник.ПользователиВЕТИС.ПустаяСсылка"));
	СтруктураОграничений.Вставить("ПраваДоступа",      Новый Массив());
	СтруктураОграничений.Вставить("Предприятия",       Новый Массив());
	СтруктураОграничений.Вставить("Адреса",            Новый Массив());
	
	Возврат СтруктураОграничений;
	
КонецФункции

// Проверяет корректность указания СНИЛС физического лица
//
Функция ЭтоСНИЛС(СНИЛС, РазрешатьПустой = Истина) Экспорт
	
	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛС, "-", "");
	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛСТолькоЦифры, " ", "");
	
	Возврат (ПустаяСтрока(СНИЛС) И РазрешатьПустой)
		ИЛИ (СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СНИЛСТолькоЦифры)
			И СтрДлина(СНИЛСТолькоЦифры) = 11
			И Сред(СНИЛС, 4, 1) = "-" 
			И Сред(СНИЛС, 8, 1) = "-" 
			И Сред(СНИЛС, 12, 1) = " ");
	
КонецФункции

// Проверяет корректность указания учетной записи
//
Функция ЭтоУчетнаяЗапись(УчетнаяЗапись,
	РазрешенаЛатинница = Истина, РазрешеныЦифры = Истина, РазрешенаКириллица = Ложь,
	РазрешеныСпецсимволы = Истина, РазрешенныеСпецсимволы = ".-") Экспорт
	
	Диапазоны = Новый Массив;
	
	Если РазрешенаЛатинница Тогда
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 65, 90)); 		// латиница большие
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 97, 122)); 		// латиница маленькие
	КонецЕсли;
	
	Если РазрешеныЦифры Тогда
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 48, 57)); 		// цифры
	КонецЕсли;
	
	Если РазрешенаКириллица Тогда
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 1040, 1103)); 	// кириллица
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 1025, 1025)); 	// символ "Ё"
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 1105, 1105)); 	// символ "ё"
	КонецЕсли;
	
	Если РазрешеныСпецсимволы Тогда
		Диапазоны.Добавить(Новый Структура("Мин,Макс", 95, 95)); 		// символ "_"
		
		Для Позиция = 1 По СтрДлина(РазрешенныеСпецсимволы) Цикл
			КодСимвола = КодСимвола(РазрешенныеСпецсимволы, Позиция);
			Диапазоны.Добавить(Новый Структура("Мин,Макс", КодСимвола, КодСимвола));
		КонецЦикла;
	КонецЕсли;
	
	ДлинаУчетнойЗаписи = СтрДлина(УчетнаяЗапись);
	
	Для Позиция = 1 По ДлинаУчетнойЗаписи Цикл
		КодСимвола = КодСимвола(УчетнаяЗапись, Позиция);
		ЭтоДопустимыйСимвол = Ложь;
		
		Для Каждого Диапазон Из Диапазоны Цикл
			Если КодСимвола >= Диапазон.Мин И КодСимвола <= Диапазон.Макс Тогда
				ЭтоДопустимыйСимвол = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ЭтоДопустимыйСимвол Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;

КонецФункции

#КонецОбласти
