﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ДатаСеанса() Экспорт
	Возврат ОбщегоНазначенияБПО.ДатаСеанса();
КонецФункции

#Область РаботаСXML

// Функция читает корневой элемент XML.
//
// Параметры:
//  СтрокаXML - Строка - XML строка.
//
// Возвращаемое значение:
//  Структура
//
Функция ПрочитатьКорневойЭлементXML(СтрокаXML) Экспорт
	
	Возврат ОбщегоНазначенияБПО.ПрочитатьКорневойЭлементXML(СтрокаXML);
	
КонецФункции

#КонецОбласти

// Возвращает истина если данные аутентификации пользователя интернет поддержки заполнены
//
// Возвращаемое значение:
//  Булево
//
Функция ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Экспорт
	
	// Вызов БИП
	Если ОбщегоНазначенияБПО.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.БазоваяФункциональностьБИП") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначенияБПО.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	// Конец Вызов БИП
	
	Возврат Ложь;
	
КонецФункции

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//   ИмяСобытия - Строка
//   Комментарий - Строка, Неопределено -
//   Метаданные - ОбъектМетаданных - 
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытия, Комментарий = Неопределено, ПредставлениеУровня = "Ошибка", Метаданные = Неопределено) Экспорт
	
	ОбщегоНазначенияБПО.ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытия, Комментарий, ПредставлениеУровня, Метаданные);
	
КонецПроцедуры

#КонецОбласти
